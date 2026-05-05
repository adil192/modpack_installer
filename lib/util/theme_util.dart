import 'package:dynamic_yaru/dynamic_yaru.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installer/util/stows.dart';
import 'package:installer/util/text_theme_extension.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:yaru/yaru.dart';

abstract class ThemeUtil {
  static Brightness? _lastBrightness;

  static ThemeData getTheme(Brightness brightness) {
    if (brightness != _lastBrightness) {
      _lastBrightness = brightness;
      DynamicYaru.refresh();
    }

    final yaruTheme = brightness == .light
        ? YaruVariant.adwaitaGreen.theme
        : YaruVariant.adwaitaGreen.darkTheme;
    final dynamicYaru = DynamicYaru.getTheme();

    final typography = Typography.material2021(
      platform: defaultTargetPlatform,
      colorScheme: yaruTheme.colorScheme,
    );
    final baseTextTheme = brightness == .light
        ? typography.black
        : typography.white;

    final nesTheme = flutterNesTheme(
      primaryColor: yaruTheme.colorScheme.primary,
      brightness: yaruTheme.brightness,
      textTheme: stows.useMinecraftFont.value
          ? baseTextTheme._withMinecraftFont()
          : baseTextTheme._withAccessibleFont(),
      customExtensions: [...yaruTheme.extensions.values],
    );
    if (dynamicYaru != null && dynamicYaru.brightness == brightness) {
      return nesTheme.copyWith(
        scaffoldBackgroundColor: dynamicYaru.scaffoldBackgroundColor,
        colorScheme: dynamicYaru.colorScheme,
      );
    } else {
      return nesTheme;
    }
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
