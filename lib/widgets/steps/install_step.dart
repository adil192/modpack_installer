import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:installer/compute/downloader.dart';
import 'package:installer/compute/installer.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:path/path.dart' as p;

class InstallStep extends StatefulWidget {
  const InstallStep({super.key});

  @override
  State<InstallStep> createState() => _InstallStepState();
}

class _InstallStepState extends State<InstallStep> {
  late final instance = PrismLauncher.selectedInstance!;
  late final modpackDir = Downloader.outputDir!;
  late final installer = Installer(instance: instance, modpackDir: modpackDir);

  late final changelogFile = File(p.join(modpackDir.path, 'CHANGELOG.md'));
  late final changelogContent = changelogFile.existsSync()
      ? changelogFile.readAsStringSync()
      : 'No changelog available.';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Install!',
          style: TextTheme.of(context).headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'You are about to update your '
          '${instance.cfgName} instance '
          'with the modpack you just downloaded.',
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          constraints: const BoxConstraints(minHeight: 200, maxHeight: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: GptMarkdown(
              changelogContent,
              style: TextTheme.of(context).bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: NesButton(
            type: NesButtonType.primary,
            onPressed: () {},
            child: const Text('Install Modpack'),
          ),
        ),
      ],
    );
  }
}
