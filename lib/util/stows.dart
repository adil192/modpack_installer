import 'package:flutter/material.dart';
import 'package:stow_plain/stow_plain.dart';

final stows = Stows();

@visibleForTesting
class Stows {
  final useMinecraftFont = PlainStow('useMinecraftFont', true);

  final prismDir = PlainStow<String?>('prismDir', null);
}
