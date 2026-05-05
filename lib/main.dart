import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:installer/compute/self_updater.dart';
import 'package:installer/home_page.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/theme_util.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrismLauncher.init();
  await Future.wait([
    windowManager.ensureInitialized(),
    stows.useMinecraftFont.waitUntilRead(),
  ]);

  unawaited(selfUpdater.init());

  _addLicenses();

  runApp(const MyApp());
}

void _addLicenses() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/fonts/Monocraft.license',
    );
    yield LicenseEntryWithLineBreaks(['Monocraft'], license);
  });

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/painting/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['Faithful-32x-Java'], license);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    stows.useMinecraftFont.addListener(_onFontPreferenceChanged);
  }

  @override
  void dispose() {
    stows.useMinecraftFont.removeListener(_onFontPreferenceChanged);
    super.dispose();
  }

  void _onFontPreferenceChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final highContrast = MediaQuery.highContrastOf(context);

    var theme = ThemeUtil.getTheme(platformBrightness);
    if (highContrast) {
      theme = theme.copyWith(
        colorScheme: platformBrightness == .light
            ? yaruHighContrastLight.colorScheme
            : yaruHighContrastDark.colorScheme,
      );
    }

    return MaterialApp(
      title: 'adil192\'s modpack installer',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const HomePage(),
    );
  }
}
