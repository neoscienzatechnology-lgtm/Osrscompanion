import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Open boxes for favorites, settings, goals
  await Hive.openBox('favorites');
  await Hive.openBox('settings');
  await Hive.openBox('goals');
  await Hive.openBox('watchlist');
  
  runApp(
    const ProviderScope(
      child: OSRSCompanionApp(),
    ),
  );
}

class OSRSCompanionApp extends ConsumerWidget {
  const OSRSCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'OSRS Companion',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      
      // Localization
      locale: locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Routing
      routerConfig: router,
    );
  }
}

// Locale provider for language selection
final localeProvider = StateProvider<Locale>((ref) {
  // Get saved locale from settings, default to English
  final settingsBox = Hive.box('settings');
  final languageCode = settingsBox.get('language', defaultValue: 'en') as String;
  return Locale(languageCode);
});
