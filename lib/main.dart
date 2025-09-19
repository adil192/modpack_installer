import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:installer/home_page.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/theme_util.dart';

Future<void> main() async {
  PrismLauncher.init();
  await stows.useMinecraftFont.waitUntilRead();

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
    return MaterialApp(
      title: 'adil192\'s modpack installer',
      theme: ThemeUtil.lightTheme,
      darkTheme: ThemeUtil.darkTheme,
      home: const HomePage(),
    );
  }
}
