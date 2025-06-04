import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:installer/home_page.dart';
import 'package:installer/widgets/theme_provider.dart';

void main() {
  PrismLauncher.init();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/fonts/Monocraft.license',
    );
    yield LicenseEntryWithLineBreaks(['Monocraft'], license);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, lightTheme, darkTheme) {
        return MaterialApp(
          title: 'adil192\'s modpack installer',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const HomePage(),
        );
      },
    );
  }
}
