import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/skill.dart';
import '../../../../core/utils/xp_utils.dart';

final selectedSkillProvider = StateProvider<Skill?>((ref) => null);
final currentLevelProvider = StateProvider<int>((ref) => 1);
final targetLevelProvider = StateProvider<int>((ref) => 99);
final currentXpProvider = StateProvider<int>((ref) => 0);

class XpCalculatorPage extends ConsumerStatefulWidget {
  const XpCalculatorPage({super.key});

  @override
  ConsumerState<XpCalculatorPage> createState() => _XpCalculatorPageState();
}

class _XpCalculatorPageState extends ConsumerState<XpCalculatorPage> {
  final DataService _dataService = DataService();
  List<Skill> _skills = [];

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    final skills = await _dataService.loadSkills();
    setState(() {
      _skills = skills;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedSkill = ref.watch(selectedSkillProvider);
    final currentLevel = ref.watch(currentLevelProvider);
    final targetLevel = ref.watch(targetLevelProvider);
    final currentXp = ref.watch(currentXpProvider);

    final targetXp = XpUtils.getXpForLevel(targetLevel);
    final xpNeeded = XpUtils.getXpNeeded(currentXp, targetLevel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('XP Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Skill Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Skill',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Skill>(
                      value: selectedSkill,
                      decoration: const InputDecoration(
                        hintText: 'Choose a skill',
                      ),
                      items: _skills.map((skill) {
                        return DropdownMenuItem(
                          value: skill,
                          child: Text(skill.name),
                        );
                      }).toList(),
                      onChanged: (skill) {
                        ref.read(selectedSkillProvider.notifier).state = skill;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Current Level/XP
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Level',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Level'),
                              Slider(
                                value: currentLevel.toDouble(),
                                min: 1,
                                max: 98,
                                divisions: 97,
                                label: currentLevel.toString(),
                                onChanged: (value) {
                                  final level = value.toInt();
                                  ref.read(currentLevelProvider.notifier).state = level;
                                  ref.read(currentXpProvider.notifier).state =
                                      XpUtils.getXpForLevel(level);
                                },
                              ),
                              Text(
                                'Level $currentLevel',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current XP: ${XpUtils.formatXp(currentXp)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Target Level
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Level',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: targetLevel.toDouble(),
                      min: (currentLevel + 1).toDouble(),
                      max: 99,
                      divisions: 99 - currentLevel - 1,
                      label: targetLevel.toString(),
                      onChanged: (value) {
                        ref.read(targetLevelProvider.notifier).state = value.toInt();
                      },
                    ),
                    Text(
                      'Level $targetLevel',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Target XP: ${XpUtils.formatXp(targetXp)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Results
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'XP Needed',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      XpUtils.formatXp(xpNeeded),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: currentLevel / targetLevel,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((currentLevel / targetLevel) * 100).toStringAsFixed(1)}% Complete',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Training Methods
            if (selectedSkill != null) ...[
              Text(
                'Suggested Methods',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...selectedSkill.trainingMethods
                  .where((method) {
                    final range = method.levelRange.split('-');
                    final minLevel = int.parse(range[0]);
                    final maxLevel = int.parse(range[1]);
                    return currentLevel >= minLevel && currentLevel <= maxLevel;
                  })
                  .map((method) {
                    final hours = XpUtils.getEstimatedHours(xpNeeded, method.xpPerHour);
                    return Card(
                      child: ListTile(
                        title: Text(method.method),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${XpUtils.formatXp(method.xpPerHour)} XP/hr'),
                            Text('Estimated time: ${XpUtils.formatTime(hours)}'),
                          ],
                        ),
                        trailing: Text(
                          method.gpCost >= 0
                              ? '-${XpUtils.formatGp(method.gpCost)}'
                              : '+${XpUtils.formatGp(-method.gpCost)}',
                          style: TextStyle(
                            color: method.gpCost >= 0 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ],
        ),
      ),
    );
  }
}
