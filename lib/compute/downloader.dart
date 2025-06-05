import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';

abstract class Downloader {
  /// The current download task, null if not downloading.
  static DownloadTask? _currentTask;

  /// The output file of the current download task,
  /// or the last completed download task if not downloading.
  ///
  /// This file will not exist until the download is complete,
  /// unless it was already there and about to be overwritten.
  static File? outputFile;

  /// The progress of the current download task,
  /// or the last completed download task if not downloading.
  static final progress = ValueNotifier<TaskProgressUpdate?>(null);

  /// The status of the current download task.
  static final status = ValueNotifier(TaskStatus.canceled);

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
    status.value = TaskStatus.canceled;

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
    outputFile = await _currentTask!.filePath().then(File.new);
  }

  static void _onUpdate(TaskUpdate update) async {
    switch (update) {
      case TaskStatusUpdate():
        status.value = update.status;
        if (update.status == TaskStatus.complete) {
          print('Downloader: Download completed successfully.');
          _currentTask = null;
        }
      case TaskProgressUpdate():
        progress.value = update;
    }
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
