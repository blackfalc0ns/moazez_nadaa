class AppSettings {
  const AppSettings({
    required this.pushNotifications,
    required this.urgentSound,
    required this.vibration,
    required this.autoOpenUrgentCalls,
    required this.shiftMode,
    required this.language,
    required this.syncOverWifiOnly,
    required this.hideSensitiveData,
  });

  final bool pushNotifications;
  final bool urgentSound;
  final bool vibration;
  final bool autoOpenUrgentCalls;
  final String shiftMode;
  final String language;
  final bool syncOverWifiOnly;
  final bool hideSensitiveData;
}
