import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import '../../../../core/models/xp_goal.dart';
import '../../../../core/utils/xp_utils.dart';
import '../../../../core/constants/app_constants.dart';

final xpGoalsProvider = StateNotifierProvider<XpGoalsNotifier, List<XpGoal>>((ref) {
  return XpGoalsNotifier();
});

class XpGoalsNotifier extends StateNotifier<List<XpGoal>> {
  XpGoalsNotifier() : super([]) {
    _loadGoals();
  }

  void _loadGoals() {
    final goalsBox = Hive.box('goals');
    final goalsList = goalsBox.get('xp_goals', defaultValue: []) as List;
    state = goalsList
        .map((json) => XpGoal.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  void addGoal(XpGoal goal) {
    state = [...state, goal];
    _saveGoals();
  }

  void removeGoal(String id) {
    state = state.where((goal) => goal.id != id).toList();
    _saveGoals();
  }

  void _saveGoals() {
    final goalsBox = Hive.box('goals');
    goalsBox.put('xp_goals', state.map((g) => g.toJson()).toList());
  }
}

class XpGoalsPage extends ConsumerWidget {
  const XpGoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(xpGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('XP Goals'),
      ),
      body: goals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text('No goals set yet'),
                  const SizedBox(height: 8),
                  const Text(
                    'Add a goal to track your XP progress',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return _GoalCard(goal: goal);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const _AddGoalDialog(),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  final XpGoal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (goal.currentXp / goal.targetXp * 100).clamp(0, 100);

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
                  goal.skillId.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(xpGoalsProvider.notifier).removeGoal(goal.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Level ${goal.currentLevel} → ${goal.targetLevel}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${progress.toStringAsFixed(1)}% Complete'),
                Text('${XpUtils.formatXp(goal.xpNeeded)} XP needed'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddGoalDialog extends ConsumerStatefulWidget {
  const _AddGoalDialog();

  @override
  ConsumerState<_AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends ConsumerState<_AddGoalDialog> {
  String? selectedSkill;
  int currentLevel = 1;
  int targetLevel = 99;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedSkill,
            decoration: const InputDecoration(labelText: 'Skill'),
            items: AppConstants.skillIds
                .map((skill) => DropdownMenuItem(
                      value: skill,
                      child: Text(skill.toUpperCase()),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedSkill = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Text('Current Level: $currentLevel'),
          Slider(
            value: currentLevel.toDouble(),
            min: 1,
            max: 98,
            divisions: 97,
            label: currentLevel.toString(),
            onChanged: (value) {
              setState(() {
                currentLevel = value.toInt();
                if (targetLevel <= currentLevel) {
                  targetLevel = currentLevel + 1;
                }
              });
            },
          ),
          Text('Target Level: $targetLevel'),
          Slider(
            value: targetLevel.toDouble(),
            min: (currentLevel + 1).toDouble(),
            max: 99,
            divisions: 99 - currentLevel - 1,
            label: targetLevel.toString(),
            onChanged: (value) {
              setState(() {
                targetLevel = value.toInt();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedSkill == null
              ? null
              : () {
                  final goal = XpGoal(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    skillId: selectedSkill!,
                    currentLevel: currentLevel,
                    targetLevel: targetLevel,
                    currentXp: XpUtils.getXpForLevel(currentLevel),
                    targetXp: XpUtils.getXpForLevel(targetLevel),
                    createdAt: DateTime.now(),
                  );
                  ref.read(xpGoalsProvider.notifier).addGoal(goal);
                  Navigator.pop(context);
                },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
