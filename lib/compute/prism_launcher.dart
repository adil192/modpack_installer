import 'dart:io';

import 'package:installer/compute/prism_instance.dart';
import 'package:installer/util/value_error_pair.dart';
import 'package:path/path.dart' as p;

abstract class PrismLauncher {
  static void init() async {
    prismDir = _findPrismDir();
    instances = await _findPrismInstances();
  }

  static late ValueErrorPair<Directory> prismDir;
  static Directory get prismDirOrThrow =>
      prismDir.hasValue ? prismDir.value! : throw prismDir.error;

  static PrismInstance? selectedInstance;
  static List<PrismInstance>? instances;

  static ValueErrorPair<Directory> _findPrismDir() {
    for (var dirPath in _potentialPrismDirs) {
      dirPath = dirPath
          .replaceWithEnv('~', 'HOME')
          .replaceWithEnv('%APPDATA%', 'APPDATA')
          .replaceWithEnv('%LOCALAPPDATA%', 'LOCALAPPDATA')
          .replaceWithEnv('%HOMEPATH%', 'HOMEPATH');
      final dir = Directory(dirPath);
      if (dir.existsSync()) {
        return ValueErrorPair.value(dir);
      }
    }

    return ValueErrorPair.error(
      FileSystemException(
        'Prism Launcher data directory not found.\n'
        'Please ensure Prism Launcher is installed and has been run at least once.',
      ),
    );
  }

  static Future<List<PrismInstance>> _findPrismInstances() async {
    final prismDir = PrismLauncher.prismDir.value;
    if (prismDir == null) return const [];

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
    if (Platform.isLinux) ...[
      '~/.var/app/org.prismlauncher.PrismLauncher/data/PrismLauncher',
      '~/.local/share/prismlauncher',
    ],
    if (Platform.isMacOS) '~/Library/Application Support/PrismLauncher',
    if (Platform.isWindows) ...[
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
