import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_locale_controller.dart';
import 'core/utils/helper/on_genrated_routes.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
