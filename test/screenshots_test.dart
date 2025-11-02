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
import 'package:yaru/yaru.dart';

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
        PrismLauncher.instances = [getChadInstance(), getJoshyInstance()];
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
        PrismLauncher.instances = [getChadInstance(), getJoshyInstance()];
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

PrismInstance getChadInstance() =>
    PrismInstance.unprocessed(Directory('${stows.prismDir.value}/chad_forge'))
      ..cfgName = 'chad_forge'
      ..cfgExportVersion = '2.7.0'
      ..cfgManagedPackID = 'https://modpacks.example.com/chad_forge.zip'
      ..minecraftVersion = '1.21.1'
      ..modLoader = 'NeoForge'
      ..modLoaderVersion = '21.1.209'
      ..generateColors();
PrismInstance getJoshyInstance() =>
    PrismInstance.unprocessed(Directory('${stows.prismDir.value}/joshy'))
      ..cfgName = 'joshy'
      ..cfgExportVersion = '1.6.1'
      ..cfgManagedPackID = 'https://modpacks.example.com/joshy.zip'
      ..minecraftVersion = '1.21.1'
      ..modLoader = 'NeoForge'
      ..modLoaderVersion = '21.1.209'
      ..generateColors();

Future<void> _screenshotApp(WidgetTester tester, String goldenFilePath) async {
  await tester.pumpWidget(_HomeApp());
  await tester.loadFonts();
  await tester.precacheImagesInWidgetTree();
  await tester.pumpAndSettle();
  await expectLater(find.byType(HomePage), matchesGoldenFile(goldenFilePath));
}

class _HomeApp extends StatelessWidget {
  const _HomeApp();

  @override
  Widget build(BuildContext context) {
    return ScreenshotApp(
      device: GoldenScreenshotDevices.flathub.device,
      theme: ThemeUtil.lightTheme,
      home: const YaruTitleBarTheme(
        data: YaruTitleBarThemeData(style: YaruTitleBarStyle.undecorated),
        child: HomePage(
          titleBar: YaruWindowTitleBar(
            title: Text("adil192's modpack installer"),
            style: YaruTitleBarStyle.normal,
            isActive: true,
            isClosable: true,
            isMaximizable: true,
            isMinimizable: true,
          ),
        ),
      ),
    );
  }
}
