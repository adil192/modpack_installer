import 'package:flutter/material.dart';

extension TextThemeExtension on TextTheme {
  TextTheme withFont({
    required String? fontFamily,
    required List<String>? fontFamilyFallback,
  }) => copyWith(
    displayLarge: displayLarge?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    displayMedium: displayMedium?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    displaySmall: displaySmall?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headlineLarge: headlineLarge?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headlineMedium: headlineMedium?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    headlineSmall: headlineSmall?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    titleLarge: titleLarge?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    titleMedium: titleMedium?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    titleSmall: titleSmall?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodyLarge: bodyLarge?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodyMedium: bodyMedium?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    bodySmall: bodySmall?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    labelLarge: labelLarge?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    labelMedium: labelMedium?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
    labelSmall: labelSmall?.copyWith(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    ),
  );
}
