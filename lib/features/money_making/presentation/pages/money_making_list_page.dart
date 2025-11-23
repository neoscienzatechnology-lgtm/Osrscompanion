import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/money_method.dart';
import '../../../../core/utils/xp_utils.dart';

final moneyMethodsProvider = FutureProvider<List<MoneyMethod>>((ref) async {
  final dataService = DataService();
  return dataService.loadMoneyMethods();
});

final methodCategoryFilterProvider = StateProvider<String?>((ref) => null);

class MoneyMakingListPage extends ConsumerWidget {
  const MoneyMakingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodsAsync = ref.watch(moneyMethodsProvider);
    final categoryFilter = ref.watch(methodCategoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Making'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              ref.read(methodCategoryFilterProvider.notifier).state =
                  value == 'all' ? null : value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'combat', child: Text('Combat')),
              const PopupMenuItem(value: 'skill', child: Text('Skill-based')),
              const PopupMenuItem(value: 'merchant', child: Text('Merchant')),
            ],
          ),
        ],
      ),
      body: methodsAsync.when(
        data: (methods) {
          var filtered = methods;
          if (categoryFilter != null) {
            filtered = methods.where((m) => m.category == categoryFilter).toList();
          }
          
          // Sort by GP/hour
          filtered.sort((a, b) => b.gpPerHour.compareTo(a.gpPerHour));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final method = filtered[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(method.name),
                  subtitle: Text(method.description),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${XpUtils.formatGp(method.gpPerHour)}/hr',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        method.difficulty.toUpperCase(),
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  onTap: () => context.push('/money-making/${method.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
