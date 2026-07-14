abstract class PushTokenLifecycle {
  Future<void> initialize();

  Future<void> ensureRegistered();

  Future<void> unregisterCurrentDevice();

  Stream<void> get notificationHints;
}
