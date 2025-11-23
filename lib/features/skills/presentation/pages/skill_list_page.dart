import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/skill.dart';

final skillsProvider = FutureProvider<List<Skill>>((ref) async {
  final dataService = DataService();
  return dataService.loadSkills();
});

class SkillListPage extends ConsumerWidget {
  const SkillListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(skillsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
      ),
      body: skillsAsync.when(
        data: (skills) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final skill = skills[index];
              return _SkillCard(skill: skill);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/skills/${skill.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getSkillIcon(skill.id),
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              skill.name,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            if (skill.members)
              const Icon(Icons.star, size: 12),
          ],
        ),
      ),
    );
  }

  IconData _getSkillIcon(String skillId) {
    switch (skillId) {
      case 'attack':
        return Icons.sports_martial_arts;
      case 'strength':
        return Icons.fitness_center;
      case 'defence':
        return Icons.shield;
      case 'mining':
        return Icons.terrain;
      case 'woodcutting':
        return Icons.park;
      case 'fishing':
        return Icons.phishing;
      case 'cooking':
        return Icons.local_dining;
      default:
        return Icons.stars;
    }
  }
}
