import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../data/settings_dummy_data.dart';
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
  bool _pushNotifications = SettingsDummyData.initial.pushNotifications;
  bool _urgentSound = SettingsDummyData.initial.urgentSound;
  bool _vibration = SettingsDummyData.initial.vibration;
  bool _autoOpenUrgentCalls = SettingsDummyData.initial.autoOpenUrgentCalls;
  bool _syncOverWifiOnly = SettingsDummyData.initial.syncOverWifiOnly;
  bool _hideSensitiveData = SettingsDummyData.initial.hideSensitiveData;
  String _shiftMode = SettingsDummyData.initial.shiftMode;
  String _language = SettingsDummyData.initial.language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الإعدادات'),
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
            title: 'التنبيهات والصوت',
            children: [
              SettingsSwitchTile(
                icon: Iconsax.notification_status,
                title: 'تنبيهات النداء',
                subtitle: 'استقبال الطلبات العاجلة والتأخيرات',
                value: _pushNotifications,
                onChanged: (value) =>
                    setState(() => _pushNotifications = value),
              ),
              SettingsSwitchTile(
                icon: Iconsax.volume_high,
                title: 'صوت الطلب العاجل',
                subtitle: 'تشغيل صوت مميز عند النداءات الحرجة',
                value: _urgentSound,
                onChanged: (value) => setState(() => _urgentSound = value),
              ),
              SettingsSwitchTile(
                icon: Iconsax.mobile,
                title: 'اهتزاز الجهاز',
                subtitle: 'تنبيه سريع أثناء المناوبة',
                value: _vibration,
                onChanged: (value) => setState(() => _vibration = value),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          SettingsSection(
            title: 'التشغيل والمناوبة',
            children: [
              SettingsDropdownTile(
                icon: Iconsax.calendar_tick,
                title: 'وضع المناوبة',
                value: _shiftMode,
                values: SettingsDummyData.shiftModes,
                onChanged: (value) => setState(() => _shiftMode = value),
              ),
              SettingsSwitchTile(
                icon: Iconsax.flash_1,
                title: 'فتح الطلب العاجل تلقائيا',
                subtitle: 'ينقلك مباشرة إلى الطلب عند وصوله',
                value: _autoOpenUrgentCalls,
                onChanged: (value) =>
                    setState(() => _autoOpenUrgentCalls = value),
              ),
              SettingsActionTile(
                icon: Iconsax.refresh,
                title: 'مزامنة بيانات البوابات',
                subtitle: 'آخر تحديث منذ دقيقتين',
                onTap: () {},
              ),
            ],
          ),
          AppSpacing.verticalSpaceMd,
          SettingsSection(
            title: 'اللغة والخصوصية',
            children: [
              SettingsDropdownTile(
                icon: Iconsax.language_square,
                title: 'لغة التطبيق',
                value: _language,
                values: SettingsDummyData.languages,
                onChanged: (value) => setState(() => _language = value),
              ),
              SettingsSwitchTile(
                icon: Iconsax.wifi,
                title: 'المزامنة عبر Wi-Fi فقط',
                subtitle: 'تقليل استهلاك البيانات أثناء المناوبة',
                value: _syncOverWifiOnly,
                onChanged: (value) => setState(() => _syncOverWifiOnly = value),
              ),
              SettingsSwitchTile(
                icon: Iconsax.eye_slash,
                title: 'إخفاء البيانات الحساسة',
                subtitle: 'إخفاء جزئي للهويات وأرقام التواصل',
                value: _hideSensitiveData,
                onChanged: (value) =>
                    setState(() => _hideSensitiveData = value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
