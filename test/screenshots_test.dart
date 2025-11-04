import 'dart:io';

import 'package:flutter/material.dart' hide Step;
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:installer/compute/prism_instance.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:installer/compute/step_controller.dart';
import 'package:installer/home_page.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/theme_util.dart';
import 'package:installer/widgets/steps/select_modpack_step.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Screenshots', () {
    SharedPreferences.setMockInitialValues({});

    group('findPrismLauncher', () {
      testGoldens('error', (tester) async {
        stepController.markStepComplete(Step.welcome, delayNext: false);
        stows.prismDir.value = null;
        await _screenshotApp(tester, 'goldens/1_find_prism_launcher_error.png');
      });
    });

    group('selectInstance', () {
      setUp(() {
        stepController.markStepComplete(Step.welcome, delayNext: false);
        stows.prismDir.value = '/home/tester/.local/share/prismlauncher';
        stepController.markStepComplete(
          Step.findPrismLauncher,
          delayNext: false,
        );
      });
      testGoldens('empty', (tester) async {
        PrismLauncher.instances = [];
        await _screenshotApp(tester, 'goldens/2_select_instance_empty.png');
      });
      testGoldens('non-empty', (tester) async {
        PrismLauncher.instances = [getVanillaInstance(), getPixelmonInstance()];
        await _screenshotApp(tester, 'goldens/2_select_instance_non_empty.png');
      });
    });

    group('selectModpack', () {
      setUp(() {
        stepController.markStepComplete(Step.welcome, delayNext: false);
        stows.prismDir.value = '/home/tester/.local/share/prismlauncher';
        stepController.markStepComplete(
          Step.findPrismLauncher,
          delayNext: false,
        );
        PrismLauncher.instances = [getVanillaInstance(), getPixelmonInstance()];
        PrismLauncher.selectedInstance = PrismLauncher.instances!.first;
        stepController.markStepComplete(Step.selectInstance, delayNext: false);
      });
      testGoldens('empty', (tester) async {
        PrismLauncher.selectedInstance = PrismLauncher.selectedInstance!
            .copyWith(cfgManagedPackID: '', preserveColors: true);
        SelectModpackStep.modpackUrl.value = null;
        await _screenshotApp(tester, 'goldens/3_select_modpack_empty.png');
      });
      testGoldens('filled', (tester) async {
        SelectModpackStep.findInitialModpackUrl();
        await _screenshotApp(tester, 'goldens/3_select_modpack_filled.png');
      });
    });
  });
}

PrismInstance getVanillaInstance() =>
    PrismInstance.unprocessed(Directory('${stows.prismDir.value}/Vanilla Plus'))
      ..cfgName = 'Vanilla+'
      ..cfgExportVersion = '2.7.0'
      ..cfgManagedPackID = 'https://modpacks.example.com/VanillaPlus.zip'
      ..minecraftVersion = '1.20.1'
      ..modLoader = 'Fabric'
      ..modLoaderVersion = '0.17.3'
      ..generateColors();
PrismInstance getPixelmonInstance() =>
    PrismInstance.unprocessed(Directory('${stows.prismDir.value}/pixelmon'))
      ..cfgName = 'pixelmon'
      ..cfgExportVersion = '1.6.1'
      ..cfgManagedPackID = 'https://modpacks.example.com/pixelmon.zip'
      ..minecraftVersion = '1.21.1'
      ..modLoader = 'NeoForge'
      ..modLoaderVersion = '21.1.209'
      ..generateColors();

Future<void> _screenshotApp(WidgetTester tester, String goldenFilePath) async {
  await tester.pumpWidget(_HomeApp());
  await tester.loadFonts();
  await tester.precacheImagesInWidgetTree();
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile(goldenFilePath),
  );
}

class _HomeApp extends StatelessWidget {
  const _HomeApp();

  @override
  Widget build(BuildContext context) {
    return ScreenshotApp.withConditionalTitlebar(
      device: GoldenScreenshotDevices.flathub.device,
      title: "adil192's modpack installer",
      theme: ThemeUtil.lightTheme,
      home: HomePage(),
    );
  }
}
