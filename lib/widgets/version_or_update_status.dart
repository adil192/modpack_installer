import 'package:flutter/material.dart';
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
            // TODO: Show update dialog instead of launching URL directly
            launchUrl(
              Uri.parse(availableUpdate.downloadUrl),
              mode: LaunchMode.externalApplication,
            );
          },
          type: NesButtonType.normal,
          text: 'Update available: ${availableUpdate.versionName}',
        );
      },
    );
  }
}
