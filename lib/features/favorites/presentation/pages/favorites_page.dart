import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesBox = Hive.box('favorites');
    final allFavorites = favoritesBox.keys
        .where((key) => favoritesBox.get(key) == true)
        .toList();

    final questFavorites =
        allFavorites.where((key) => key.toString().startsWith('quest_')).toList();
    final methodFavorites =
        allFavorites.where((key) => key.toString().startsWith('method_')).toList();

    final hasFavorites = allFavorites.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: hasFavorites
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (questFavorites.isNotEmpty) ...[
                  Text(
                    'Quests',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...questFavorites.map((key) {
                    final id = key.toString().replaceFirst('quest_', '');
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(id.replaceAll('_', ' ').toUpperCase()),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            favoritesBox.put(key, false);
                            // Trigger rebuild
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        onTap: () => context.push('/quests/$id'),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
                if (methodFavorites.isNotEmpty) ...[
                  Text(
                    'Money Making Methods',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...methodFavorites.map((key) {
                    final id = key.toString().replaceFirst('method_', '');
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.attach_money),
                        title: Text(id.replaceAll('_', ' ').toUpperCase()),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            favoritesBox.put(key, false);
                            // Trigger rebuild
                            (context as Element).markNeedsBuild();
                          },
                        ),
                        onTap: () => context.push('/money-making/$id'),
                      ),
                    );
                  }),
                ],
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text('No favorites yet'),
                  const SizedBox(height: 8),
                  const Text(
                    'Add quests or methods to favorites for quick access',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
