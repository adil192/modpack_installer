import 'package:flutter/material.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/text_theme_extension.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:yaru/yaru.dart';

abstract class ThemeUtil {
  static ThemeData get lightTheme => _getTheme(Brightness.light);
  static ThemeData get darkTheme => _getTheme(Brightness.dark);

  static ThemeData _getTheme(Brightness brightness) {
    final yaruTheme = brightness == Brightness.light
        ? YaruVariant.adwaitaGreen.theme
        : YaruVariant.adwaitaGreen.darkTheme;
    final nesTheme = flutterNesTheme(
      primaryColor: yaruTheme.colorScheme.primary,
      brightness: yaruTheme.brightness,
    );
    return yaruTheme.copyWith(
      colorScheme: nesTheme.colorScheme,
      textTheme: stows.useMinecraftFont.value
          ? nesTheme.textTheme._withMinecraftFont()
          : nesTheme.textTheme._withAccessibleFont(),
      extensions: [
        ...yaruTheme.extensions.values,
        ...nesTheme.extensions.values,
      ],
    );
  }
}

extension on TextTheme {
  TextTheme _withMinecraftFont() {
    return withFont(
      fontFamily: 'Monocraft',
      fontFamilyFallback: [
        'PressStart2P', // provided by nes_ui
        'Segoe UI',
        'Ubuntu',
        'packages/yaru/Ubuntu',
        'sans-serif',
      ],
    );
  }

  TextTheme _withAccessibleFont() {
    return withFont(
      fontFamily: 'Atkinson Hyperlegible Next',
      fontFamilyFallback: [
        'AtkinsonHyperlegibleNext',
        'Atkinson Hyperlegible',
        'AtkinsonHyperlegible',
        'Segoe UI',
        'Adwaita Sans',
        'Inter',
        'system-ui',
        'Noto Sans',
        'Cantarell',
        'Roboto',
        'Ubuntu',
        'packages/yaru/Ubuntu',
        'sans-serif',
      ],
    );
  }
}
