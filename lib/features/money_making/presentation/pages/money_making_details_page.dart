import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/money_method.dart';
import '../../../../core/utils/xp_utils.dart';

final methodDetailsProvider =
    FutureProvider.family<MoneyMethod?, String>((ref, methodId) async {
  final dataService = DataService();
  return dataService.getMoneyMethodById(methodId);
});

class MoneyMakingDetailsPage extends ConsumerWidget {
  final String methodId;

  const MoneyMakingDetailsPage({super.key, required this.methodId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodAsync = ref.watch(methodDetailsProvider(methodId));

    return methodAsync.when(
      data: (method) {
        if (method == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Method not found')),
          );
        }

        final favoritesBox = Hive.box('favorites');
        final isFavorite =
            favoritesBox.get('method_${method.id}', defaultValue: false) as bool;

        return Scaffold(
          appBar: AppBar(
            title: Text(method.name),
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  favoritesBox.put('method_${method.id}', !isFavorite);
                  ref.invalidate(methodDetailsProvider(methodId));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profit',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${XpUtils.formatGp(method.gpPerHour)}/hr',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow('Category', method.category.toUpperCase()),
                        _InfoRow('Difficulty', method.difficulty.toUpperCase()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(method.description),
                const SizedBox(height: 16),
                if (method.requirements['skills'] != null &&
                    (method.requirements['skills'] as Map).isNotEmpty) ...[
                  Text(
                    'Requirements',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            (method.requirements['skills'] as Map<String, dynamic>)
                                .entries
                                .map((entry) => _InfoRow(entry.key, 'Level ${entry.value}'))
                                .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Guide',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: method.steps.asMap().entries.map((entry) {
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
                              Expanded(child: Text(entry.value)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (method.items.isNotEmpty) ...[
                  Text(
                    'Items Needed',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: method.items
                        .map((item) => Chip(label: Text(item)))
                        .toList(),
                  ),
                ],
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
