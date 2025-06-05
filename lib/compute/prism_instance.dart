import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

typedef JsonMap = Map<String, dynamic>;

class PrismInstance {
  final Directory instanceDir;

  late final instanceCfgFile = File(p.join(instanceDir.path, 'instance.cfg'));
  late var cfgName = 'Unknown instance';
  late var cfgExportVersion = '';
  late var cfgManagedPackID = '';

  late final mmcPackJsonFile = File(p.join(instanceDir.path, 'mmc-pack.json'));
  late var minecraftVersion = '';
  late var modLoader = '';
  late var modLoaderVersion = '';

  var primaryColorLight = Colors.transparent;
  var primaryColorDark = Colors.transparent;
  var secondaryColorLight = Colors.transparent;
  var secondaryColorDark = Colors.transparent;

  void generateColors() {
    final primaryTint = _genTintFromHash(
      cfgName.hashCode ^ cfgExportVersion.hashCode ^ cfgManagedPackID.hashCode,
      Colors.primaries,
    );
    final secondaryTint = _genTintFromHash(
      cfgName.hashCode ^ minecraftVersion.hashCode ^ modLoaderVersion.hashCode,
      Colors.accents,
    );
    primaryColorLight = Color.lerp(Colors.white, primaryTint, 0.1)!;
    primaryColorDark = Color.lerp(Colors.black, primaryTint, 0.1)!;
    secondaryColorLight = Color.lerp(Colors.white, secondaryTint, 0.15)!;
    secondaryColorDark = Color.lerp(Colors.black, secondaryTint, 0.15)!;
  }

  Color _genTintFromHash(int hash, List<Color> colors) {
    final index = (hash % colors.length).toInt();
    return colors[index];
  }

  /// Known mod loaders mapped from their cachedName to their display name.
  static const _knownModLoaders = {
    'NeoForge': 'NeoForge',
    'Fabric Loader': 'Fabric',
    'Forge': 'Forge',
    'Quilt': 'Quilt',
  };

  PrismInstance._(this.instanceDir);
  static Future<PrismInstance> fromDirectory(Directory instanceDir) async {
    final instance = PrismInstance._(instanceDir);

    if (instance.instanceCfgFile.existsSync()) {
      final cfgLines = await instance.instanceCfgFile.readAsLines();
      for (final line in cfgLines) {
        final split = line.split('=');
        if (split.length != 2) continue;
        final key = split.first.trim();
        late final value = split.last.trim();
        switch (key) {
          case 'ExportVersion':
            instance.cfgExportVersion = value;
          case 'ManagedPackID':
            instance.cfgManagedPackID = value;
          case 'name':
            instance.cfgName = value;
        }
      }
    }

    if (instance.mmcPackJsonFile.existsSync()) {
      final mmcPackJsonContent = await instance.mmcPackJsonFile.readAsString();
      final mmcPackJson = jsonDecode(mmcPackJsonContent) as JsonMap;
      final components = mmcPackJson['components'] as List? ?? const [];
      for (final JsonMap component in components) {
        final cachedName = component['cachedName'] as String?;
        final cachedVersion = component['cachedVersion'] as String?;

        if (cachedName == 'Minecraft') {
          instance.minecraftVersion = cachedVersion ?? '';
        } else if (_knownModLoaders.containsKey(cachedName)) {
          instance.modLoader = _knownModLoaders[cachedName]!;
          instance.modLoaderVersion = cachedVersion ?? '';
        }
      }
    }

    instance.generateColors();

    print(
      '${instance.cfgName} instance found: '
      'ExportVersion=${instance.cfgExportVersion}, '
      'ManagedPackID=${instance.cfgManagedPackID}, '
      'Minecraft=${instance.minecraftVersion}, '
      'ModLoader=${instance.modLoader} ${instance.modLoaderVersion}',
    );

    return instance;
  }
}
