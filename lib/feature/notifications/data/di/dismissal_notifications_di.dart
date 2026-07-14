import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/api/api_service.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/realtime/realtime_service.dart';
import '../../../../core/services/notifications/push_token_lifecycle.dart';
import '../../presentation/cubits/dismissal_notification_details_cubit.dart';
import '../../presentation/cubits/dismissal_notifications_cubit.dart';
import '../repo/dismissal_notifications_repo.dart';
import '../services/dismissal_notification_push_service.dart';

class DismissalNotificationsDI {
  const DismissalNotificationsDI._();

  static void init(GetIt sl) {
    sl.registerLazySingleton<DismissalNotificationsRepo>(
      () => DismissalNotificationsRepoImpl(apiService: sl<ApiService>()),
    );
    sl.registerLazySingleton<PushTokenLifecycle>(
      () => DismissalNotificationPushService(
        notificationsRepo: sl<DismissalNotificationsRepo>(),
        messaging: FirebaseMessaging.instance,
        permissionRepository: sl<PermissionRepository>(),
        secureStorage: sl<FlutterSecureStorage>(),
        localNotifications: FlutterLocalNotificationsPlugin(),
      ),
    );
    sl.registerFactory<DismissalNotificationsCubit>(
      () => DismissalNotificationsCubit(
        repo: sl<DismissalNotificationsRepo>(),
        realtime: sl<RealtimeService>(),
        pushTokenLifecycle: sl<PushTokenLifecycle>(),
      ),
    );
    sl.registerFactory<DismissalNotificationDetailsCubit>(
      () => DismissalNotificationDetailsCubit(
        repo: sl<DismissalNotificationsRepo>(),
      ),
    );
  }
}
