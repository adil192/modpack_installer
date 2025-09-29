import 'package:flutter/material.dart' hide Step;
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:installer/compute/step_controller.dart';
import 'package:installer/home_page.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/theme_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaru/yaru.dart';

void main() {
  group('Screenshots', () {
    SharedPreferences.setMockInitialValues({});

    group('findPrismLauncher', () {
      testGoldens('error', (tester) async {
        stows.prismDir.value = null;
        stepController.markStepComplete(Step.welcome, delayNext: false);

        await tester.pumpWidget(_HomeApp());
        await tester.loadFonts();
        await tester.precacheImagesInWidgetTree();
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(HomePage),
          matchesGoldenFile('goldens/find_prism_launcher_error.png'),
        );
      });
    });
  });
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

class FakeBuildContext extends Fake implements BuildContext {}
