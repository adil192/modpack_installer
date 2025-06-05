import 'dart:io';

import 'package:flutter/material.dart';

class Installer {
  Installer({required this.extractedModpackDir, required this.instanceDir});

  final Directory extractedModpackDir;
  final Directory instanceDir;
}
