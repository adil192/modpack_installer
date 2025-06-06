import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class Downloader {
  /// The current download task, null if not downloading.
  static DownloadTask? _currentTask;

  /// The output file of the current download task,
  /// or the last completed download task if not downloading.
  ///
  /// This file will not exist until the download is complete,
  /// unless it was already there and about to be overwritten.
  static File? _outputZip;

  /// The output directory of the current download task,
  /// or the last completed download task if not downloading.
  ///
  /// This directory will not exist until the download is complete
  /// AND [hasExtracted] is true.
  static Directory? outputDir;

  /// The progress of the current download task,
  /// or the last completed download task if not downloading.
  static final progress = ValueNotifier<TaskProgressUpdate?>(null);

  /// The status of the current download task.
  /// You should also check the related [hasExtracted] boolean
  /// to determine if the Downloader is fully done.
  static final status = ValueNotifier(TaskStatus.enqueued);

  /// Whether the [_outputZip] has finished extracting.
  /// If true, [status] will be [TaskStatus.complete].
  static bool hasExtracted = false;

  static StreamSubscription<TaskUpdate>? _subscription;
  static void _ensureSubscribed() {
    _subscription ??= FileDownloader().updates.listen(_onUpdate);
  }

  static void startDownload(Uri modpackUrl) async {
    if (modpackUrl.toString() == _currentTask?.url &&
        status.value.isNotFinalState) {
      print('Downloader: Already downloading this modpack URL.');
      return;
    } else if (_currentTask != null) {
      cancel();
    }

    print('Downloader: Starting download of `$modpackUrl`');

    _currentTask = null;
    progress.value = null;
    status.value = TaskStatus.enqueued;
    hasExtracted = false;
    outputDir = null;

    _currentTask = null;
    _currentTask = await DownloadTask(
      url: modpackUrl.toString(),
      baseDirectory: BaseDirectory.temporary,
      directory: 'modpacks',
      updates: Updates.statusAndProgress,
    ).withSuggestedFilename();

    _ensureSubscribed();
    final enqueued = await FileDownloader().enqueue(_currentTask!);
    if (!enqueued) {
      print('Downloader: Failed to enqueue download task.');
      _currentTask = null;
      status.value = TaskStatus.failed;
      return;
    }
    _outputZip = await _currentTask!.filePath().then(File.new);
  }

  static void _onUpdate(TaskUpdate update) {
    switch (update) {
      case TaskStatusUpdate():
        status.value = update.status;
        if (update.status == TaskStatus.complete) {
          _onComplete();
        }
      case TaskProgressUpdate():
        progress.value = update;
    }
  }

  static void _onComplete() async {
    if (_currentTask == null) return;
    _currentTask = null;
    hasExtracted = false;
    print('Downloader: Download completed successfully to $_outputZip.');

    final modpackNameWithExtension = _outputZip!.uri.pathSegments.last;
    final modpackNameWithoutExtension = modpackNameWithExtension.substring(
      0,
      modpackNameWithExtension.lastIndexOf('.'),
    );

    final tmpDirectory = await getTemporaryDirectory();
    outputDir = Directory(
      p.join(tmpDirectory.path, 'modpacks', modpackNameWithoutExtension),
    );
    if (outputDir!.existsSync()) {
      await outputDir!.delete(recursive: true);
    }
    outputDir!.createSync(recursive: true);

    await extractFileToDisk(_outputZip!.path, outputDir!.path);

    print('Downloader: Extracted modpack to $outputDir.');
    _outputZip = null;
    hasExtracted = true;
    status.value = TaskStatus.complete;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    status.notifyListeners();
  }

  static void cancel() {
    if (_currentTask != null) {
      print('Downloader: Cancelling download of `${_currentTask!.url}`');
      unawaited(FileDownloader().cancel(_currentTask!));
    }
    _currentTask = null;
    progress.value = null;
    status.value = TaskStatus.canceled;
  }

  static void dispose() {
    cancel();
    progress.dispose();
    status.dispose();
  }
}
