import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class PremiumPaywallPage extends ConsumerWidget {
  const PremiumPaywallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.workspace_premium,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Upgrade to Premium',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Features List
            _FeatureTile(
              icon: Icons.block,
              title: 'Remove All Ads',
              description: 'Enjoy an ad-free experience',
            ),
            _FeatureTile(
              icon: Icons.notifications_active,
              title: 'GE Price Alerts',
              description: 'Get notified when prices change',
            ),
            _FeatureTile(
              icon: Icons.analytics,
              title: 'Advanced XP Planner',
              description: 'Track multiple goals with detailed analytics',
            ),
            _FeatureTile(
              icon: Icons.route,
              title: 'Premium Training Routes',
              description: 'Access exclusive efficient training methods',
            ),
            _FeatureTile(
              icon: Icons.palette,
              title: 'Custom Themes',
              description: 'Unlock additional color themes',
            ),

            const SizedBox(height: 32),

            // Price Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '\$4.99',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text('One-time purchase'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => _purchasePremium(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
              child: const Text(
                'Unlock Premium',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => _restorePurchase(context),
              child: const Text('Restore Purchase'),
            ),
          ],
        ),
      ),
    );
  }

  void _purchasePremium(BuildContext context) {
    // In a real app, this would trigger IAP
    final settingsBox = Hive.box('settings');
    settingsBox.put('is_premium', true);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Activated!'),
        content: const Text(
          'Thank you for upgrading to Premium! Enjoy all the exclusive features.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _restorePurchase(BuildContext context) {
    // In a real app, this would check with IAP server
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking for previous purchases...'),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
