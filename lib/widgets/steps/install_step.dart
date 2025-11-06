import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
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
  late final changelogContent = _readChangelog();

  String _readChangelog() {
    final wholeChangelog = changelogFile.existsSync()
        ? changelogFile.readAsStringSync()
        : 'No changelog available.';

    final end = nthHeadingIndex(wholeChangelog, 2);
    if (end == -1) {
      return wholeChangelog;
    } else {
      return wholeChangelog.substring(0, end).trim();
    }
  }

  int nthHeadingIndex(String content, int n) {
    var prevIndex = -1;
    for (var i = 0; i < n; ++i) {
      final nextIndex = content.indexOf('\n#', prevIndex + 1);
      print('nthHeadingIndex: Found heading $i at $nextIndex');
      if (nextIndex == -1) return -1;
      prevIndex = nextIndex;
    }
    return prevIndex;
  }

  @override
  void initState() {
    super.initState();
    installer.addListener(_onInstallerUpdate);
  }

  @override
  void dispose() {
    installer.removeListener(_onInstallerUpdate);
    super.dispose();
  }

  bool _shownConfetti = false;

  void _onInstallerUpdate() {
    if (installer.finishedInstalling && !_shownConfetti && mounted) {
      _shownConfetti = true;
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 200, spread: 70, y: 0.9),
      );
    } else if (!installer.finishedInstalling) {
      _shownConfetti = false;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

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
            color: colorScheme.surface,
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
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: NesContainer(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: NesButton(
                    type: NesButtonType.primary,
                    onPressed: installer.isInstalling
                        ? null
                        : installer.startInstall,
                    child: installer.isInstalling
                        ? const Text('Installing...')
                        : const Text('Install Modpack'),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: installer.log.isEmpty ? 0 : 200,
                    maxHeight: 400,
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.topCenter,
                    child: installer.log.isEmpty
                        ? const SizedBox(width: double.infinity)
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NesContainer(
                              label: 'Log',
                              child: ListView.builder(
                                reverse: true,
                                itemCount: installer.log.length,
                                itemBuilder: (context, index) {
                                  if (index >= installer.log.length) {
                                    return null;
                                  }
                                  final logEntry = installer
                                      .log[installer.log.length - 1 - index];
                                  return Text(
                                    logEntry,
                                    style: TextTheme.of(context).bodyMedium,
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
