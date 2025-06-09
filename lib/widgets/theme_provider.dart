import 'package:flutter/material.dart';
import 'package:installer/util/text_theme_extension.dart';
import 'package:nes_ui/nes_ui.dart';

class ThemeProvider extends StatefulWidget {
  const ThemeProvider({super.key, required this.builder});
  final Widget Function(
    BuildContext context,
    ThemeData lightTheme,
    ThemeData darkTheme,
  )
  builder;

  static ThemeProviderData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedThemeProvider>()
        ?.notifier;
  }

  static ThemeProviderData of(BuildContext context) {
    final ThemeProviderData? result = maybeOf(context);
    assert(result != null, 'No ThemeProviderData found in context');
    return result!;
  }

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
  final ThemeProviderData _themeData = ThemeProviderData();

  @override
  Widget build(BuildContext context) {
    return _InheritedThemeProvider(
      notifier: _themeData,
      child: Builder(
        builder: (context) {
          final themeData = ThemeProvider.of(context);
          return widget.builder(
            context,
            themeData.lightTheme,
            themeData.darkTheme,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _themeData.dispose();
    super.dispose();
  }
}

class _InheritedThemeProvider extends InheritedNotifier<ThemeProviderData> {
  const _InheritedThemeProvider({
    required super.notifier,
    required super.child,
  });
}

class ThemeProviderData extends ChangeNotifier {
  /// Whether to use the Minecraft font (Monocraft).
  /// If false, a more readable font family is used.
  bool get useMinecraftFont => _useMinecraftFont;
  bool _useMinecraftFont = true;
  set useMinecraftFont(bool value) {
    if (_useMinecraftFont == value) return;
    _useMinecraftFont = value;
    notifyListeners();
  }

  ThemeData get lightTheme => _getTheme(Brightness.light);
  ThemeData get darkTheme => _getTheme(Brightness.dark);

  ThemeData _getTheme(Brightness brightness) {
    var theme = flutterNesTheme(
      primaryColor: Colors.green,
      brightness: brightness,
    );
    theme = theme.copyWith(
      textTheme: useMinecraftFont
          ? _applyMinecraftFont(theme.textTheme)
          : _applyAccessibleFont(theme.textTheme),
    );
    return theme;
  }

  TextTheme _applyMinecraftFont(TextTheme textTheme) {
    return textTheme.withFont(
      fontFamily: 'Monocraft',
      fontFamilyFallback: [
        'Monocraft',
        'PressStart2P', // provided by nes_ui
        ...textTheme.bodyMedium?.fontFamilyFallback ?? [],
      ],
    );
  }

  TextTheme _applyAccessibleFont(TextTheme textTheme) {
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
