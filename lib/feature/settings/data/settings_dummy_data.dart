import 'models/app_settings.dart';

class SettingsDummyData {
  const SettingsDummyData._();

  static const initial = AppSettings(
    pushNotifications: true,
    urgentSound: true,
    vibration: true,
    autoOpenUrgentCalls: false,
    shiftMode: 'مناوبة الخروج',
    language: 'العربية',
    syncOverWifiOnly: false,
    hideSensitiveData: true,
  );

  static const shiftModes = ['مناوبة الخروج', 'مناوبة صباحية', 'مناوبة مسائية'];
  static const languages = ['العربية', 'English'];
}
