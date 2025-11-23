import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/skill.dart';
import '../../../../core/utils/xp_utils.dart';

final skillDetailsProvider = FutureProvider.family<Skill?, String>((ref, skillId) async {
  final dataService = DataService();
  return dataService.getSkillById(skillId);
});

class SkillDetailsPage extends ConsumerWidget {
  final String skillId;

  const SkillDetailsPage({super.key, required this.skillId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillAsync = ref.watch(skillDetailsProvider(skillId));

    return skillAsync.when(
      data: (skill) {
        if (skill == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Skill Not Found')),
            body: const Center(child: Text('Skill not found')),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(skill.name),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Training Methods'),
                  Tab(text: 'XP Table'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _TrainingMethodsTab(skill: skill),
                _XpTableTab(skill: skill),
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

class _TrainingMethodsTab extends StatelessWidget {
  final Skill skill;

  const _TrainingMethodsTab({required this.skill});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          skill.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Text(
          'Training Methods',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...skill.trainingMethods.map((method) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Levels ${method.levelRange}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${XpUtils.formatXp(method.xpPerHour)} XP/hr',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    method.method,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        method.gpCost >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: method.gpCost >= 0 ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        method.gpCost >= 0
                            ? '${XpUtils.formatGp(method.gpCost)} cost'
                            : '${XpUtils.formatGp(-method.gpCost)} profit',
                        style: TextStyle(
                          color: method.gpCost >= 0 ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  if (method.items.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Items needed:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: method.items
                          .map((item) => Chip(
                                label: Text(item),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _XpTableTab extends StatelessWidget {
  final Skill skill;

  const _XpTableTab({required this.skill});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: skill.xpTable.length,
      itemBuilder: (context, index) {
        final entry = skill.xpTable[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Text(
                  '${entry.level}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text('${XpUtils.formatXp(entry.xp)} XP'),
            trailing: index < skill.xpTable.length - 1
                ? Text(
                    '+${XpUtils.formatXp(skill.xpTable[index + 1].xp - entry.xp)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
