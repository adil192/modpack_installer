import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaru/yaru.dart';

class BorderedWindow extends StatefulWidget {
  const BorderedWindow({super.key, required this.child});

  final Widget? child;

  @override
  State<BorderedWindow> createState() => _BorderedWindowState();
}

class _BorderedWindowState extends State<BorderedWindow> with WindowListener {
  static var _lastBorderColor = Colors.transparent;
  static final _childKey = GlobalKey();
  static var _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.isMaximized().then((value) {
      _isMaximized = value;
      if (mounted) setState(() {});
    });
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() {
    _isMaximized = true;
    if (mounted) setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    _isMaximized = false;
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    final borderColor = Color.alphaBlend(
      YaruTitleBarTheme.of(context).border?.color ??
          (Theme.brightnessOf(context) == Brightness.light
              ? Colors.black.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.06)),
      ColorScheme.of(context).surface,
    );
    if (borderColor != _lastBorderColor) {
      _lastBorderColor = borderColor;
      windowManager.setBackgroundColor(borderColor).catchError((_) {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    /// Use KeyedSubtree to preserve child state when adding/removing border
    final keyedChild = KeyedSubtree(
      key: _childKey,
      child: widget.child ?? const SizedBox(),
    );

    final showBorder = !_isMaximized;
    return showBorder
        ? ColoredBox(
            color: _lastBorderColor,
            child: Padding(padding: const EdgeInsets.all(1), child: keyedChild),
          )
        : keyedChild;
  }
}
