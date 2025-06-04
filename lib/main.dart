import 'package:flutter/material.dart';
import 'package:installer/home_page.dart';
import 'package:installer/widgets/theme_provider.dart';

void main() {
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
