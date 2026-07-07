import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../../core/realtime/realtime_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../generated/app_localizations.dart';
import '../widgets/settings_action_tile.dart';
import '../widgets/settings_dropdown_tile.dart';
import '../widgets/settings_header_card.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _pushKey = 'dismissal_push_notifications';
  static const _soundKey = 'dismissal_urgent_sound';
  static const _vibrationKey = 'dismissal_vibration';
  static const _autoOpenKey = 'dismissal_auto_open_urgent';
  static const _wifiOnlyKey = 'dismissal_wifi_only';
  static const _hideSensitiveKey = 'dismissal_hide_sensitive';
  static const _shiftModeKey = 'dismissal_shift_mode';

  bool _pushNotifications = true;
  bool _urgentSound = true;
  bool _vibration = true;
  bool _autoOpenUrgentCalls = false;
  bool _syncOverWifiOnly = false;
  bool _hideSensitiveData = true;
  String _shiftMode = 'dismissal';

  SharedPreferences get _prefs => sl<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    setState(() {
      _pushNotifications = _prefs.getBool(_pushKey) ?? true;
      _urgentSound = _prefs.getBool(_soundKey) ?? true;
      _vibration = _prefs.getBool(_vibrationKey) ?? true;
      _autoOpenUrgentCalls = _prefs.getBool(_autoOpenKey) ?? false;
      _syncOverWifiOnly = _prefs.getBool(_wifiOnlyKey) ?? false;
      _hideSensitiveData = _prefs.getBool(_hideSensitiveKey) ?? true;
      _shiftMode = _prefs.getString(_shiftModeKey) ?? 'dismissal';
    });
  }

  Future<void> _setBool(
    String key,
    bool value,
    ValueSetter<bool> update,
  ) async {
    setState(() => update(value));
    await _prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = sl<AppLocaleController>();
    final shiftValues = [
      l10n.settingsShiftDismissal,
      l10n.settingsShiftMorning,
      l10n.settingsShiftEvening,
    ];
    final shiftLabels = {
      'dismissal': l10n.settingsShiftDismissal,
      'morning': l10n.settingsShiftMorning,
      'evening': l10n.settingsShiftEvening,
    };
    final languageValues = [
      l10n.settingsLanguageArabic,
      l10n.settingsLanguageEnglish,
    ];

    return Scaffold(
      appBar: CustomAppBar(title: l10n.dismissalSettingsTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          const SettingsHeaderCard(),
          AppSpacing.verticalSpaceMd,
          SettingsSection(
            title: l10n.settingsNotificationsSound,
            children: [
              SettingsSwitchTile(
                icon: Iconsax.notification_status,
                title: l10n.settingsDismissalNotifications,
                subtitle: l10n.settingsDismissalNotificationsSubtitle,
                value: _pushNotifications,
                onChanged: (value) => _setBool(
                  _pushKey,
                  value,
                  (next) => _pushNotifications = next,
                ),
              ),
              SettingsSwitchTile(
                icon: Iconsax.volume_high,
                title: l10n.settingsUrgentSound,
                subtitle: l10n.settingsUrgentSoundSubtitle,
                value: _urgentSound,
                onChanged: (value) =>
                    _setBool(_soundKey, value, (next) => _urgentSound = next),
              ),
              SettingsSwitchTile(
                icon: Iconsax.mobile,
                title: l10n.settingsVibration,
                subtitle: l10n.settingsVibrationSubtitle,
                value: _vibration,
                onChanged: (value) =>
                    _setBool(_vibrationKey, value, (next) => _vibration = next),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          SettingsSection(
            title: l10n.settingsOperationsShift,
            children: [
              SettingsDropdownTile(
                icon: Iconsax.calendar_tick,
                title: l10n.settingsShiftMode,
                value: shiftLabels[_shiftMode] ?? l10n.settingsShiftDismissal,
                values: shiftValues,
                onChanged: (value) async {
                  final code = shiftLabels.entries
                      .firstWhere(
                        (entry) => entry.value == value,
                        orElse: () => const MapEntry('dismissal', ''),
                      )
                      .key;
                  setState(() => _shiftMode = code);
                  await _prefs.setString(_shiftModeKey, code);
                },
              ),
              SettingsSwitchTile(
                icon: Iconsax.flash_1,
                title: l10n.settingsAutoOpenUrgent,
                subtitle: l10n.settingsAutoOpenUrgentSubtitle,
                value: _autoOpenUrgentCalls,
                onChanged: (value) => _setBool(
                  _autoOpenKey,
                  value,
                  (next) => _autoOpenUrgentCalls = next,
                ),
              ),
              SettingsActionTile(
                icon: Iconsax.refresh,
                title: l10n.settingsSyncGates,
                subtitle: l10n.settingsSyncGatesSubtitle,
                onTap: () async {
                  await sl<RealtimeService>().forceReconnect();
                  if (!context.mounted) return;
                  PremiumSnackbar.success(
                    context,
                    message: l10n.settingsSyncSuccess,
                  );
                },
              ),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          SettingsSection(
            title: l10n.settingsLanguagePrivacy,
            children: [
              SettingsDropdownTile(
                icon: Iconsax.language_square,
                title: l10n.settingsAppLanguage,
                value: localeController.languageCode == 'en'
                    ? l10n.settingsLanguageEnglish
                    : l10n.settingsLanguageArabic,
                values: languageValues,
                onChanged: (value) => localeController.setLocale(
                  Locale(value == l10n.settingsLanguageEnglish ? 'en' : 'ar'),
                ),
              ),
              SettingsSwitchTile(
                icon: Iconsax.wifi,
                title: l10n.settingsWifiOnly,
                subtitle: l10n.settingsWifiOnlySubtitle,
                value: _syncOverWifiOnly,
                onChanged: (value) => _setBool(
                  _wifiOnlyKey,
                  value,
                  (next) => _syncOverWifiOnly = next,
                ),
              ),
              SettingsSwitchTile(
                icon: Iconsax.eye_slash,
                title: l10n.settingsHideSensitive,
                subtitle: l10n.settingsHideSensitiveSubtitle,
                value: _hideSensitiveData,
                onChanged: (value) => _setBool(
                  _hideSensitiveKey,
                  value,
                  (next) => _hideSensitiveData = next,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
