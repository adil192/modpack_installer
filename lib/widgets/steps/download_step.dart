import 'package:background_downloader/background_downloader.dart';
import 'package:basics/basics.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/downloader.dart';
import 'package:installer/compute/step_controller.dart';
import 'package:installer/widgets/steps/select_modpack_step.dart';
import 'package:nes_ui/nes_ui.dart';

class DownloadStep extends StatefulWidget {
  const DownloadStep({super.key});

  @override
  State<DownloadStep> createState() => _DownloadStepState();
}

class _DownloadStepState extends State<DownloadStep> {
  @override
  void initState() {
    super.initState();
    Downloader.startDownload(SelectModpackStep.modpackUrl.value!);
    Downloader.progress.addListener(_onProgressUpdate);
    Downloader.status.addListener(_onStatusUpdate);
  }

  void _onProgressUpdate() {
    final progressUpdate = Downloader.progress.value;
    if (progressUpdate == null) return;

    print('DownloadStep: Progress update: $progressUpdate');

    if (mounted) setState(() {});
  }

  void _onStatusUpdate() {
    print('DownloadStep: Status update: ${Downloader.status.value}');

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    Downloader.progress.removeListener(_onProgressUpdate);
    Downloader.status.removeListener(_onStatusUpdate);
    Downloader.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = Downloader.status.value;
    final progress = Downloader.progress.value;

    final finishedDownloading = status == TaskStatus.complete;
    final finishedExtracting = finishedDownloading && Downloader.hasExtracted;
    if (finishedExtracting) {
      stepController.markStepComplete(Step.download);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          finishedExtracting
              ? 'Downloaded!'
              : finishedDownloading
              ? 'Extracting...'
              : 'Downloading...',
          style: TextTheme.of(context).headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(status.name.capitalize(), textAlign: TextAlign.left),
            ),
            Expanded(
              child: Text(
                (progress != null && progress.hasNetworkSpeed)
                    ? progress.networkSpeedAsString
                    : '',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                status.isFinalState
                    ? progress?.expectedFileSizeAsString ?? ''
                    : progress?.timeRemainingAsString ?? '',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        NesProgressBar(
          value: progress?.progress ?? 0,
          label: 'Download Progress',
        ),
        if (!finishedDownloading && status.isFinalState) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              'The download failed!\n'
              'Please check your url and internet connection and try again.',
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              Flexible(
                child: NesButton(
                  type: NesButtonType.normal,
                  onPressed: () {
                    Downloader.cancel();
                    SelectModpackStep.deselect();
                    stepController.goBackToStep(Step.selectModpack);
                  },
                  child: const Text('Back'),
                ),
              ),
              Flexible(
                child: NesButton(
                  type: NesButtonType.normal,
                  onPressed: () {
                    Downloader.cancel();
                    Downloader.startDownload(
                      SelectModpackStep.modpackUrl.value!,
                    );
                  },
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

extension on TaskProgressUpdate {
  String get expectedFileSizeAsString {
    var quantity = expectedFileSize.toDouble();
    if (quantity < 0) return '';

    for (final unit in ['B', 'KB', 'MB', 'GB']) {
      if (quantity < 1024) {
        return '${quantity.toStringAsFixed(2)} $unit';
      }
      quantity /= 1024;
    }

    return '${quantity.toStringAsFixed(2)} TB';
  }
}
