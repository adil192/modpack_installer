import 'package:flutter/material.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/text_theme_extension.dart';
import 'package:nes_ui/nes_ui.dart';

abstract class ThemeUtil {
  static ThemeData get lightTheme => _getTheme(Brightness.light);
  static ThemeData get darkTheme => _getTheme(Brightness.dark);

  static ThemeData _getTheme(Brightness brightness) {
    var theme = flutterNesTheme(
      primaryColor: Colors.green,
      brightness: brightness,
    );
    theme = theme.copyWith(
      textTheme: stows.useMinecraftFont.value
          ? _applyMinecraftFont(theme.textTheme)
          : _applyAccessibleFont(theme.textTheme),
    );
    return theme;
  }

  static TextTheme _applyMinecraftFont(TextTheme textTheme) {
    return textTheme.withFont(
      fontFamily: 'Monocraft',
      fontFamilyFallback: [
        'Monocraft',
        'PressStart2P', // provided by nes_ui
        ...textTheme.bodyMedium?.fontFamilyFallback ?? [],
      ],
    );
  }

  static TextTheme _applyAccessibleFont(TextTheme textTheme) {
    return textTheme.withFont(
      fontFamily: 'Atkinson Hyperlegible',
      fontFamilyFallback: [
        'Atkinson Hyperlegible',
        'Adwaita Sans',
        // https://github.com/system-fonts/modern-font-stacks#neo-grotesque
        'Inter',
        'Roboto',
        'Helvetica Neue',
        'Arial Nova',
        'Nimbus Sans',
        'Arial',
        'sans-serif',
      ],
    );
  }
}
