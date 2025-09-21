import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:installer/home_page.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/theme_util.dart';
import 'package:yaru/yaru.dart';

Future<void> main() async {
  PrismLauncher.init();
  await Future.wait([
    YaruWindowTitleBar.ensureInitialized(),
    stows.useMinecraftFont.waitUntilRead(),
  ]);

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/fonts/Monocraft.license',
    );
    yield LicenseEntryWithLineBreaks(['Monocraft'], license);
  });

  runApp(const MyApp());
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
    final lightTheme = ThemeUtil.lightTheme;
    final darkTheme = ThemeUtil.darkTheme;
    final highContrastTheme = lightTheme.copyWith(
      colorScheme: yaruHighContrastLight.colorScheme,
    );
    final highContrastDarkTheme = darkTheme.copyWith(
      colorScheme: yaruHighContrastDark.colorScheme,
    );

    return MaterialApp(
      title: 'adil192\'s modpack installer',
      debugShowCheckedModeBanner: false,
      theme: ThemeUtil.lightTheme,
      darkTheme: ThemeUtil.darkTheme,
      highContrastTheme: highContrastTheme,
      highContrastDarkTheme: highContrastDarkTheme,
      home: const HomePage(),
    );
  }
}
