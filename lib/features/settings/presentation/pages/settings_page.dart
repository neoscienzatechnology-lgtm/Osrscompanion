import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../main.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsBox = Hive.box('settings');
    final currentLanguage = settingsBox.get('language', defaultValue: 'en') as String;
    final isPremium = settingsBox.get('is_premium', defaultValue: false) as bool;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Language Section
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(L10n.getLanguageName(currentLanguage)),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const Divider(),

          // Premium Section
          if (!isPremium)
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('Upgrade to Premium'),
              subtitle: const Text('Remove ads and unlock premium features'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.push('/premium'),
            ),
          
          if (isPremium)
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text('Premium Active'),
              subtitle: Text('Thank you for your support!'),
            ),

          const Divider(),

          // About Section
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: Text('Version ${AppConstants.appVersion}'),
          ),

          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate App'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opens app store')),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality')),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send Feedback'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opens feedback form')),
              );
            },
          ),

          const Divider(),

          // Data Management
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Clear All Data'),
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            onTap: () => _showClearDataDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: L10n.all.map((locale) {
            return ListTile(
              title: Text(L10n.getLanguageName(locale.languageCode)),
              onTap: () async {
                final settingsBox = Hive.box('settings');
                await settingsBox.put('language', locale.languageCode);
                ref.read(localeProvider.notifier).state = locale;
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete all favorites, goals, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Hive.box('favorites').clear();
              await Hive.box('goals').clear();
              await Hive.box('watchlist').clear();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
