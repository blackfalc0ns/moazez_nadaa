import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/helper/on_genrated_routes.dart';
import 'generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MoazezChatApp());
}

class MoazezChatApp extends StatelessWidget {
  const MoazezChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'معزز',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      initialRoute: Routes.splash,
      onGenerateRoute: OnGeneratedRoutes.onGenerateRoute,
    );
  }
}
