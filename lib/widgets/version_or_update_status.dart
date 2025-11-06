import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:installer/compute/self_updater.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionOrUpdateStatus extends StatelessWidget {
  const VersionOrUpdateStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: selfUpdater,
      builder: (context, child) {
        final versionName = selfUpdater.versionName;
        if (versionName == null) {
          return const SizedBox.shrink();
        }

        final availableUpdate = selfUpdater.availableUpdate;
        if (availableUpdate == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(versionName),
          );
        }

        return NesButton.text(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  _UpdateDialog(availableUpdate: availableUpdate),
            );
          },
          type: NesButtonType.normal,
          text: 'Update available: ${availableUpdate.versionName}',
        );
      },
    );
  }
}

class _UpdateDialog extends StatelessWidget {
  const _UpdateDialog({required this.availableUpdate});

  final AvailableUpdate availableUpdate;

  void _launchDownload() => launchUrl(
    Uri.parse(availableUpdate.downloadUrl),
    mode: LaunchMode.externalApplication,
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return NesDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New version available!', style: textTheme.titleLarge),
          Text('${selfUpdater.versionName} → ${availableUpdate.versionName}'),
          const SizedBox(height: 16),
          Text('Changes:', style: textTheme.titleMedium),
          GptMarkdown(availableUpdate.changelogMd),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Tooltip(
              message: availableUpdate.downloadUrl,
              child: NesButton.text(
                onPressed: _launchDownload,
                type: NesButtonType.normal,
                text: 'Download',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
