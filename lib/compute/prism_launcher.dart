import 'dart:io';

import 'package:installer/compute/prism_instance.dart';
import 'package:installer/util/stows.dart';
import 'package:path/path.dart' as p;

abstract class PrismLauncher {
  static List<PrismInstance>? instances;

  static PrismInstance? get selectedInstance => _selectedInstance;
  static PrismInstance? _selectedInstance;
  static set selectedInstance(PrismInstance? instance) {
    _selectedInstance = instance;
    stows.selectedPrismInstanceDir.value = instance?.instanceDir.path;
  }

  static void init() async {
    await _findPrismDir();
    instances = await _findPrismInstances();
    await _restoreSelectedInstance();
  }

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

  static Future<void> _restoreSelectedInstance() async {
    await stows.selectedPrismInstanceDir.waitUntilRead();
    final selectedDirPath = stows.selectedPrismInstanceDir.value;
    if (selectedDirPath == null) return;
    final selectedDir = Directory(selectedDirPath);
    if (!selectedDir.existsSync()) return;

    try {
      _selectedInstance = await PrismInstance.fromDirectory(selectedDir);
    } catch (e, st) {
      print('Failed to restore selected Prism instance: $e\n$st');
    }
  }

  /// https://prismlauncher.org/wiki/getting-started/data-location/
  @pragma('vm:platform-const')
  static List<String> get _potentialPrismDirs {
    if (Platform.isLinux) {
      return const [
        '~/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher',
        '~/.local/share/prismlauncher',
      ];
    } else if (Platform.isMacOS) {
      return const ['~/Library/Application Support/PrismLauncher'];
    } else if (Platform.isWindows) {
      return const [
        '%APPDATA%\\PrismLauncher',
        '%LOCALAPPDATA%\\PrismLauncher',
        '%HOMEPATH%\\scoop\\persist\\prismlauncher',
      ];
    } else {
      return const [];
    }
  }
}

extension _ReplaceWithEnv on String {
  String replaceWithEnv(String from, String envKey) {
    return replaceAll(from, Platform.environment[envKey] ?? from);
  }
}
