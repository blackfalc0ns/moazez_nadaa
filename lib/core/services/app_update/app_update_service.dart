import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum AppUpdateType { optional, required }

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.type,
    required this.currentVersion,
    required this.currentBuild,
    required this.targetBuild,
    required this.storeUrl,
    this.releaseNotesAr = '',
    this.releaseNotesEn = '',
  });

  final AppUpdateType type;
  final String currentVersion;
  final int currentBuild;
  final int targetBuild;
  final String storeUrl;
  final String releaseNotesAr;
  final String releaseNotesEn;

  bool get isRequired => type == AppUpdateType.required;

  String releaseNotesFor(String languageCode) {
    return languageCode == 'ar' ? releaseNotesAr : releaseNotesEn;
  }
}

class AppUpdateService {
  AppUpdateService({
    FirebaseRemoteConfig? remoteConfig,
    Future<PackageInfo> Function()? packageInfoLoader,
  }) : _remoteConfigOverride = remoteConfig,
       _packageInfoLoader = packageInfoLoader ?? PackageInfo.fromPlatform;

  static const enabledKey = 'ndaaa_update_enabled';
  static const androidMinimumBuildKey = 'ndaaa_android_minimum_build';
  static const androidLatestBuildKey = 'ndaaa_android_latest_build';
  static const androidStoreUrlKey = 'ndaaa_android_store_url';
  static const iosMinimumBuildKey = 'ndaaa_ios_minimum_build';
  static const iosLatestBuildKey = 'ndaaa_ios_latest_build';
  static const iosStoreUrlKey = 'ndaaa_ios_store_url';
  static const releaseNotesArKey = 'ndaaa_update_release_notes_ar';
  static const releaseNotesEnKey = 'ndaaa_update_release_notes_en';

  final FirebaseRemoteConfig? _remoteConfigOverride;
  final Future<PackageInfo> Function() _packageInfoLoader;
  bool _configured = false;

  FirebaseRemoteConfig get _remoteConfig =>
      _remoteConfigOverride ?? FirebaseRemoteConfig.instance;

  Future<AppUpdateInfo?> checkForUpdate() async {
    if (!Platform.isAndroid && !Platform.isIOS) return null;

    try {
      await _configureIfNeeded();
      try {
        await _remoteConfig.fetchAndActivate();
      } catch (error) {
        // Activated cached values remain usable while the device is offline.
        if (kDebugMode) {
          debugPrint('[RemoteConfig][FETCH_ERROR] $error');
        }
      }

      if (!_remoteConfig.getBool(enabledKey)) return null;

      final packageInfo = await _packageInfoLoader();
      final currentBuild = _parseBuildNumber(packageInfo.buildNumber);
      final minimumBuild = _remoteConfig.getInt(
        Platform.isAndroid ? androidMinimumBuildKey : iosMinimumBuildKey,
      );
      final latestBuild = _remoteConfig.getInt(
        Platform.isAndroid ? androidLatestBuildKey : iosLatestBuildKey,
      );
      final updateType = evaluateUpdateType(
        currentBuild: currentBuild,
        minimumBuild: minimumBuild,
        latestBuild: latestBuild,
      );
      if (updateType == null) return null;

      final storeUrl = _remoteConfig
          .getString(Platform.isAndroid ? androidStoreUrlKey : iosStoreUrlKey)
          .trim();
      final storeUri = Uri.tryParse(storeUrl);
      if (storeUri == null || !storeUri.hasScheme) {
        if (kDebugMode) {
          debugPrint(
            '[RemoteConfig][INVALID_STORE_URL] '
            'platform=${Platform.operatingSystem}',
          );
        }
        return null;
      }

      return AppUpdateInfo(
        type: updateType,
        currentVersion: packageInfo.version,
        currentBuild: currentBuild,
        targetBuild: latestBuild > minimumBuild ? latestBuild : minimumBuild,
        storeUrl: storeUrl,
        releaseNotesAr: _remoteConfig.getString(releaseNotesArKey).trim(),
        releaseNotesEn: _remoteConfig.getString(releaseNotesEnKey).trim(),
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[RemoteConfig][UPDATE_CHECK_ERROR] $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return null;
    }
  }

  Future<bool> openStore(AppUpdateInfo update) async {
    try {
      return launchUrl(
        Uri.parse(update.storeUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[RemoteConfig][STORE_OPEN_ERROR] $error');
      }
      return false;
    }
  }

  @visibleForTesting
  static AppUpdateType? evaluateUpdateType({
    required int currentBuild,
    required int minimumBuild,
    required int latestBuild,
  }) {
    if (minimumBuild > 0 && currentBuild < minimumBuild) {
      return AppUpdateType.required;
    }
    if (latestBuild > 0 && currentBuild < latestBuild) {
      return AppUpdateType.optional;
    }
    return null;
  }

  Future<void> _configureIfNeeded() async {
    if (_configured) return;
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 8),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(minutes: 30),
      ),
    );
    await _remoteConfig.setDefaults(const {
      enabledKey: true,
      androidMinimumBuildKey: 0,
      androidLatestBuildKey: 0,
      androidStoreUrlKey:
          'https://play.google.com/store/apps/details?id=sa.moazez.nedaa',
      iosMinimumBuildKey: 0,
      iosLatestBuildKey: 0,
      iosStoreUrlKey: '',
      releaseNotesArKey: '',
      releaseNotesEnKey: '',
    });
    _configured = true;
  }

  static int _parseBuildNumber(String value) {
    return int.tryParse(value.trim()) ??
        int.tryParse(RegExp(r'\d+').firstMatch(value)?.group(0) ?? '') ??
        0;
  }
}
