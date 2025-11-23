import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OSRS Companion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _FeatureCard(
            title: 'Quest Guides',
            icon: Icons.menu_book,
            onTap: () => context.push('/quests'),
          ),
          _FeatureCard(
            title: 'Skill Guides',
            icon: Icons.trending_up,
            onTap: () => context.push('/skills'),
          ),
          _FeatureCard(
            title: 'XP Calculator',
            icon: Icons.calculate,
            onTap: () => context.push('/calculators'),
          ),
          _FeatureCard(
            title: 'Money Making',
            icon: Icons.attach_money,
            onTap: () => context.push('/money-making'),
          ),
          _FeatureCard(
            title: 'GE Tracker',
            icon: Icons.show_chart,
            onTap: () => context.push('/ge-tracker'),
          ),
          _FeatureCard(
            title: 'XP Goals',
            icon: Icons.flag,
            onTap: () => context.push('/xp-goals'),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
