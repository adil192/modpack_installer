import 'package:flutter/material.dart';
import 'package:installer/util/text_theme_extension.dart';
import 'package:nes_ui/nes_ui.dart';

class ThemeProvider extends StatelessWidget {
  const ThemeProvider({super.key, required this.builder});
  final Widget Function(
    BuildContext context,
    ThemeData lightTheme,
    ThemeData darkTheme,
  )
  builder;

  ThemeData getTheme(Brightness brightness) {
    var theme = flutterNesTheme(
      primaryColor: Colors.green,
      brightness: brightness,
    );
    theme = theme.copyWith(
      textTheme: theme.textTheme.withFont(
        fontFamily: 'Monocraft',
        fontFamilyFallback: [
          'Monocraft',
          'PressStart2P', // provided by nes_ui
          ...theme.textTheme.bodyMedium?.fontFamilyFallback ?? [],
        ],
      ),
    );
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = getTheme(Brightness.light);
    final darkTheme = getTheme(Brightness.dark);
    return builder(context, lightTheme, darkTheme);
  }
}
