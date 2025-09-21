import 'dart:io';

import 'package:installer/compute/prism_instance.dart';
import 'package:installer/util/stows.dart';
import 'package:path/path.dart' as p;

abstract class PrismLauncher {
  static void init() async {
    await _findPrismDir();
    instances = await _findPrismInstances();
  }

  static PrismInstance? selectedInstance;
  static List<PrismInstance>? instances;

  /// Sets [Stows.prismDir] if found.
  static Future<void> _findPrismDir() async {
    // Check if we already have a stored path
    await stows.prismDir.waitUntilRead();
    if (stows.prismDir.value != null) {
      final dir = Directory(stows.prismDir.value!);
      if (dir.existsSync()) return;
    }

    // Otherwise, try to find it
    for (var dirPath in _potentialPrismDirs) {
      dirPath = dirPath
          .replaceWithEnv('~', 'HOME')
          .replaceWithEnv('%APPDATA%', 'APPDATA')
          .replaceWithEnv('%LOCALAPPDATA%', 'LOCALAPPDATA')
          .replaceWithEnv('%HOMEPATH%', 'HOMEPATH');
      final dir = Directory(dirPath);
      if (dir.existsSync()) {
        stows.prismDir.value = dir.path;
        return;
      }
    }

    // Couldn't find it, do nothing
    stows.prismDir.value = null;
  }

  static Future<List<PrismInstance>> _findPrismInstances() async {
    final prismDirPath = stows.prismDir.value;
    if (prismDirPath == null) return const [];
    final prismDir = Directory(prismDirPath);

    final instancesDir = Directory(p.join(prismDir.path, 'instances'));
    if (!instancesDir.existsSync()) return const [];

    final instances = await instancesDir.list().toList();
    return Future.wait([
      for (final instance in instances)
        if (instance is Directory) PrismInstance.fromDirectory(instance),
    ]);
  }

  /// https://prismlauncher.org/wiki/getting-started/data-location/
  static final _potentialPrismDirs = [
    if (Platform.isLinux) ...const [
      '~/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher',
      '~/.local/share/prismlauncher',
    ],
    if (Platform.isMacOS) '~/Library/Application Support/PrismLauncher',
    if (Platform.isWindows) ...const [
      '%APPDATA%\\PrismLauncher',
      '%LOCALAPPDATA%\\PrismLauncher',
      '%HOMEPATH%\\scoop\\persist\\prismlauncher',
    ],
  ];
}

extension _ReplaceWithEnv on String {
  String replaceWithEnv(String from, String envKey) {
    return replaceAll(from, Platform.environment[envKey] ?? from);
  }
}
