import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:installer/compute/prism_instance.dart';
import 'package:installer/widgets/steps/select_modpack_step.dart';
import 'package:path/path.dart' as p;

class Installer extends ChangeNotifier {
  Installer({required this.instance, required this.modpackDir});

  final PrismInstance instance;
  final Directory modpackDir;

  /// If an error occurs, this will be non-null.
  String? error;

  /// True if installation completed successfully.
  bool finishedInstalling = false;

  final log = <String>[];

  bool isInstalling = false;
  void startInstall() async {
    if (isInstalling) return;

    isInstalling = true;
    finishedInstalling = false;
    log.clear();
    notifyListeners();

    try {
      await _install();
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      isInstalling = false;
      notifyListeners();
    }
  }

  Future<void> _install() async {
    log.add('Starting installation for ${instance.cfgName}...');

    if (!instance.mmcPackJsonFile.existsSync()) {
      log.add('mmc-pack.json not found: modpack structure unexpected.');
      error = log.last;
      notifyListeners();
      return;
    }

    await for (final entity in modpackDir.list(
      recursive: true,
      followLinks: true,
    )) {
      if (entity is! File) continue;

      final relativePath = p.relative(entity.path, from: modpackDir.path);
      final targetFile = File(p.join(instance.instanceDir.path, relativePath));

      final canClobber = this.canClobber(relativePath);
      if (!canClobber && targetFile.existsSync()) {
        log.add('Skipping existing file: $relativePath');
        notifyListeners();
        continue;
      } else if (!canClobber &&
          File('${targetFile.path}.disabled').existsSync()) {
        log.add('Skipping disabled file: $relativePath');
        notifyListeners();
        continue;
      }

      log.add('Copying $relativePath...');
      notifyListeners();
      try {
        await targetFile.create(recursive: true);
        await entity.copy(targetFile.path);
        notifyListeners();
      } catch (e) {
        log.add('Failed to copy ${entity.path} to ${targetFile.path}: $e');
        error = log.last;
        notifyListeners();
        return;
      }
    }

    final instanceCfg = await instance.instanceCfgFile.readAsLines();
    bool foundManagedPack = false;
    final targetManagedPack = 'ManagedPack=true';
    bool foundManagedPackID = false;
    final targetManagedPackID =
        'ManagedPackID=${SelectModpackStep.modpackUrl.value}';
    for (var i = 0; i < instanceCfg.length; i++) {
      final line = instanceCfg[i].trim();
      if (line.startsWith('ManagedPack=')) {
        foundManagedPack = true;
        if (line != targetManagedPack) {
          instanceCfg[i] = targetManagedPack;
          log.add('Updated instance.cfg: $targetManagedPack');
          notifyListeners();
        }
      } else if (line.startsWith('ManagedPackID=')) {
        foundManagedPackID = true;
        if (line != targetManagedPackID) {
          instanceCfg[i] = targetManagedPackID;
          log.add('Updated instance.cfg: $targetManagedPackID');
          notifyListeners();
        }
      } else if (line.isEmpty) {
        // add lines while we're still in the [General] section
        if (!foundManagedPack) {
          instanceCfg.insert(i, targetManagedPack);
          log.add('Added to instance.cfg: $targetManagedPack');
          notifyListeners();
          foundManagedPack = true;
        }
        if (!foundManagedPackID) {
          instanceCfg.insert(i + 1, targetManagedPackID);
          log.add('Added to instance.cfg: $targetManagedPackID');
          notifyListeners();
          foundManagedPackID = true;
        }
        break;
      }
    }
    instance.instanceCfgFile.writeAsStringSync(instanceCfg.join('\n'));

    log.add('Installation completed successfully for ${instance.cfgName}.');
    finishedInstalling = true;
    notifyListeners();
  }

  /// Whether we should overrite the file if it exists.
  bool canClobber(String relativePath) {
    // Don't replace configs
    if (relativePath.startsWith(p.join('minecraft', 'config'))) return false;
    // Don't replace server list
    if (relativePath == p.join('minecraft', 'servers.dat')) return false;
    // Don't replace mod jars
    if (relativePath.startsWith(p.join('minecraft', 'mods')) &&
        relativePath.endsWith('.jar')) {
      return false;
    }
    // Overwrite everything else
    return true;
  }
}
