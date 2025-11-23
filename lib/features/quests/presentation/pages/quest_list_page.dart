import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/quest.dart';

final questsProvider = FutureProvider<List<Quest>>((ref) async {
  final dataService = DataService();
  return dataService.loadQuests();
});

final questSearchProvider = StateProvider<String>((ref) => '');
final questDifficultyFilterProvider = StateProvider<String?>((ref) => null);
final questMembersFilterProvider = StateProvider<bool?>((ref) => null);
final questCombatFilterProvider = StateProvider<bool?>((ref) => null);

class QuestListPage extends ConsumerWidget {
  const QuestListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(questsProvider);
    final searchQuery = ref.watch(questSearchProvider);
    final difficultyFilter = ref.watch(questDifficultyFilterProvider);
    final membersFilter = ref.watch(questMembersFilterProvider);
    final combatFilter = ref.watch(questCombatFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest Guides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search quests...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                ref.read(questSearchProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: questsAsync.when(
              data: (quests) {
                // Apply filters
                var filtered = quests.where((quest) {
                  if (searchQuery.isNotEmpty &&
                      !quest.name.toLowerCase().contains(searchQuery.toLowerCase())) {
                    return false;
                  }
                  if (difficultyFilter != null && quest.difficulty != difficultyFilter) {
                    return false;
                  }
                  if (membersFilter != null && quest.members != membersFilter) {
                    return false;
                  }
                  if (combatFilter != null && quest.combat != combatFilter) {
                    return false;
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No quests found'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final quest = filtered[index];
                    return _QuestCard(quest: quest);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(questDifficultyFilterProvider.notifier).state = null;
                ref.read(questMembersFilterProvider.notifier).state = null;
                ref.read(questCombatFilterProvider.notifier).state = null;
                Navigator.pop(context);
              },
              child: const Text('Reset Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestCard extends ConsumerWidget {
  final Quest quest;

  const _QuestCard({required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesBox = Hive.box('favorites');
    final isFavorite = favoritesBox.get('quest_${quest.id}', defaultValue: false) as bool;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(quest.name),
        subtitle: Text(
          '${quest.difficulty.toUpperCase()} • ${quest.questPoints} QP',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (quest.members) const Icon(Icons.star, size: 16),
            if (quest.combat) const Icon(Icons.flash_on, size: 16),
            const SizedBox(width: 8),
            Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ],
        ),
        onTap: () => context.push('/quests/${quest.id}'),
      ),
    );
  }
}
