import 'package:flutter/material.dart';
import 'package:installer/compute/downloader.dart';
import 'package:installer/compute/installer.dart';
import 'package:installer/compute/prism_launcher.dart';

class InstallStep extends StatefulWidget {
  const InstallStep({super.key});

  @override
  State<InstallStep> createState() => _InstallStepState();
}

class _InstallStepState extends State<InstallStep> {
  late final instance = PrismLauncher.selectedInstance!;
  late final modpackDir = Downloader.outputDir!;
  late final installer = Installer(instance: instance, modpackDir: modpackDir);

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
          'Click the button below to update your '
          '${instance.cfgName} instance '
          'with the modpack you just downloaded.',
        ),
        const SizedBox(height: 8),
        
      ],
    );
  }
}
