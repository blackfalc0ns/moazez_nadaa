import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_locale_controller.dart';
import 'core/utils/helper/global_navigator.dart';
import 'core/utils/helper/on_genrated_routes.dart';
import 'feature/notifications/data/services/dismissal_notification_local_presenter.dart';
import 'firebase_options.dart';
import 'generated/app_localizations.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DismissalNotificationLocalPresenter.showDataOnlyInBackground(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await initDI();
  runApp(const MoazezChatApp());
}

class MoazezChatApp extends StatelessWidget {
  const MoazezChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = sl<AppLocaleController>();
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) => MaterialApp(
        navigatorKey: GlobalNavigator.navigatorKey,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        locale: localeController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialRoute: Routes.splash,
        onGenerateRoute: OnGeneratedRoutes.onGenerateRoute,
      ),
    );
  }
}
