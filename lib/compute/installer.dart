import 'dart:io';

import 'package:installer/compute/prism_instance.dart';

class Installer {
  Installer({required this.instance, required this.modpackDir});

  final PrismInstance instance;
  final Directory modpackDir;
}
