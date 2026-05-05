import 'package:flutter/foundation.dart';
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
    final typography = Typography.material2021(
      platform: defaultTargetPlatform,
      colorScheme: yaruTheme.colorScheme,
    );
    final baseTextTheme = brightness == Brightness.light
        ? typography.black
        : typography.white;
    return flutterNesTheme(
      primaryColor: yaruTheme.colorScheme.primary,
      brightness: yaruTheme.brightness,
      textTheme: stows.useMinecraftFont.value
          ? baseTextTheme._withMinecraftFont()
          : baseTextTheme._withAccessibleFont(),
      customExtensions: [...yaruTheme.extensions.values],
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
        'Adwaita Sans',
        'packages/yaru/Ubuntu',
        'sans-serif',
      ],
    );
  }

  TextTheme _withAccessibleFont() {
    return withFont(
      fontFamily: 'Atkinson Hyperlegible Next',
      fontFamilyFallback: [
        'Atkinson Hyperlegible',
        'Segoe UI',
        'Ubuntu',
        'Adwaita Sans',
        'Inter',
        'Noto Sans',
        'Cantarell',
        'packages/yaru/Ubuntu',
        'sans-serif',
      ],
    );
  }
}
