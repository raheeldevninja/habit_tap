import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/notification_service.dart';
import 'core/services/settings_service.dart';
import 'features/habits/data/habit_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:habit_tracker_app/l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Services
  final notificationService = NotificationService();
  await notificationService.init();

  final sharedPrefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(sharedPrefs);

  // Request Notification Permissions
  await notificationService.requestPermissions();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Repository
  final habitRepository = await HabitRepository.init(
    notificationService,
    settingsService,
  );

  // App Entry Point
  runApp(
    ProviderScope(
      overrides: [
        habitRepositoryProvider.overrideWithValue(habitRepository),
        settingsServiceProvider.overrideWithValue(settingsService),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'HabitTap',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
        Locale('es'),
        Locale('fr'),
      ],
      locale: locale,
      routerConfig: appRouter,
    );
  }
}
