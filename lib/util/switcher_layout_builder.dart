import 'package:flutter/material.dart';

/// The same as [AnimatedSwitcher.defaultLayoutBuilder],
/// but with [Alignment.topLeft].
Widget topLeftLayoutBuilder(
  Widget? currentChild,
  List<Widget> previousChildren,
) {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      ...previousChildren,
      if (currentChild != null) currentChild,
    ],
  );
}
