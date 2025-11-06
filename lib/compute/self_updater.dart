import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

final selfUpdater = _SelfUpdater();

class _SelfUpdater extends ChangeNotifier {
  /// The version name of the current build, with a `v` prefix.
  /// E.g.: `v1.2.3`
  String? versionName;

  /// The version number of the current build.
  /// E.g.: `102030`
  String? versionNumber;

  /// Details about an available update, if any.
  AvailableUpdate? availableUpdate;

  /// The GitHub API URL to fetch the latest release info.
  /// https://api.github.com/repos/adil192/modpack_installer/releases/latest
  static final releasesApiUrl = Uri.https(
    'api.github.com',
    '/repos/adil192/modpack_installer/releases/latest',
  );

  static const fallbackDownloadUrl =
      'https://github.com/adil192/modpack_installer/releases/latest';

  Future<void> init() =>
      Future.wait([_parseCurrentVersion(), _fetchLatestReleaseInfo()]);

  Future<void> _parseCurrentVersion() async {
    final pubspecYaml = await rootBundle.loadString(
      'pubspec.yaml',
      cache: false,
    );

    /// E.g.: version: 1.2.3+102030
    final versionLine = pubspecYaml
        .split('\n')
        .firstWhere((line) => line.startsWith('version:'));
    final versionParts = versionLine.split(':').last.trim().split('+');
    versionName = 'v${versionParts[0]}';
    versionNumber = versionParts[1];

    notifyListeners();
    print('SelfUpdater: Current version: $versionName ($versionNumber)');
  }

  Future<void> _fetchLatestReleaseInfo() async {
    final response = await http.read(releasesApiUrl);
    final parsed = jsonDecode(response) as Map<String, dynamic>;
    final latestVersionName = parsed['tag_name'] as String;
    if (latestVersionName == versionName) {
      print('No update available (latest: $latestVersionName)');
      return;
    }
    final changelogMd = parsed['body'] as String;

    final expectedExtension = switch (defaultTargetPlatform) {
      TargetPlatform.windows => '.exe',
      TargetPlatform.linux => '.flatpak',
      _ => throw UnsupportedError(
        'Unsupported platform for self-updates: $defaultTargetPlatform',
      ),
    };
    final assets = (parsed['assets'] as List).cast<Map<String, dynamic>>();
    String downloadUrl = fallbackDownloadUrl;
    for (final asset in assets) {
      final filename = asset['name'] as String? ?? '';
      if (!filename.endsWith(expectedExtension)) continue;
      downloadUrl =
          asset['browser_download_url'] as String? ?? fallbackDownloadUrl;
      break;
    }

    availableUpdate = AvailableUpdate(
      versionName: latestVersionName,
      changelogMd: changelogMd,
      downloadUrl: downloadUrl,
    );

    notifyListeners();
    print('SelfUpdater: Update available: $latestVersionName at $downloadUrl');
  }
}

class AvailableUpdate {
  const AvailableUpdate({
    required this.versionName,
    required this.changelogMd,
    required this.downloadUrl,
  });
  final String versionName;
  final String changelogMd;
  final String downloadUrl;
}
