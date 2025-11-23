import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/ge_item.dart';
import '../../../../core/utils/xp_utils.dart';

final geItemsProvider = FutureProvider<List<GeItem>>((ref) async {
  final dataService = DataService();
  return dataService.loadGeItems();
});

class GeTrackerPage extends ConsumerWidget {
  const GeTrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(geItemsProvider);
    final watchlistBox = Hive.box('watchlist');

    return Scaffold(
      appBar: AppBar(
        title: const Text('GE Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tap an item to view price graph'),
                ),
              );
            },
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isWatchlisted =
                  watchlistBox.get('item_${item.id}', defaultValue: false) as bool;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Row(
                    children: [
                      Text('${XpUtils.formatGp(item.price)} GP'),
                      if (item.members) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.star, size: 14),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isWatchlisted ? Icons.bookmark : Icons.bookmark_border,
                    ),
                    onPressed: () {
                      watchlistBox.put('item_${item.id}', !isWatchlisted);
                      ref.invalidate(geItemsProvider);
                    },
                  ),
                  onTap: () => context.push('/ge-tracker/${item.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              const Text('Unable to load GE items'),
              const SizedBox(height: 8),
              const Text('Make sure you have internet connection'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(geItemsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
