import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/quest.dart';

final questDetailsProvider = FutureProvider.family<Quest?, String>((ref, questId) async {
  final dataService = DataService();
  return dataService.getQuestById(questId);
});

class QuestDetailsPage extends ConsumerWidget {
  final String questId;

  const QuestDetailsPage({super.key, required this.questId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questAsync = ref.watch(questDetailsProvider(questId));

    return questAsync.when(
      data: (quest) {
        if (quest == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Quest Not Found')),
            body: const Center(child: Text('Quest not found')),
          );
        }

        final favoritesBox = Hive.box('favorites');
        final isFavorite = favoritesBox.get('quest_${quest.id}', defaultValue: false) as bool;

        return Scaffold(
          appBar: AppBar(
            title: Text(quest.name),
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  favoritesBox.put('quest_${quest.id}', !isFavorite);
                  ref.invalidate(questDetailsProvider(questId));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quest Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow('Difficulty', quest.difficulty.toUpperCase()),
                        _InfoRow('Length', quest.length.replaceAll('_', ' ').toUpperCase()),
                        _InfoRow('Quest Points', '${quest.questPoints}'),
                        _InfoRow('Members', quest.members ? 'Yes' : 'No'),
                        _InfoRow('Combat', quest.combat ? 'Yes' : 'No'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Requirements
                if (quest.requirements['skills'] != null &&
                    (quest.requirements['skills'] as Map).isNotEmpty) ...[
                  Text(
                    'Requirements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (quest.requirements['skills'] as Map<String, dynamic>)
                            .entries
                            .map((entry) => _InfoRow(entry.key, 'Level ${entry.value}'))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Rewards
                Text(
                  'Rewards',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow('Quest Points', '${quest.rewards['questPoints']}'),
                        if (quest.rewards['experience'] != null) ...[
                          const Divider(),
                          const Text('Experience Rewards:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...(quest.rewards['experience'] as Map<String, dynamic>)
                              .entries
                              .map((entry) => _InfoRow(entry.key, '${entry.value} XP')),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Quest Guide
                Text(
                  'Quest Guide',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: quest.steps.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(entry.value),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
