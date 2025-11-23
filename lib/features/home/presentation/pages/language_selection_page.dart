import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../main.dart';

class LanguageSelectionPage extends ConsumerWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.language,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Select Your Language',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ...L10n.all.map((locale) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Save selected language
                      final settingsBox = Hive.box('settings');
                      await settingsBox.put('language', locale.languageCode);
                      await settingsBox.put('first_launch', false);
                      
                      // Update locale provider
                      ref.read(localeProvider.notifier).state = locale;
                      
                      // Navigate to home
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(
                      L10n.getLanguageName(locale.languageCode),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
