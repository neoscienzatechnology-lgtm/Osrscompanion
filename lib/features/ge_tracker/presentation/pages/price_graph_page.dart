import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/services/ge_api_service.dart';
import '../../../../core/models/ge_item.dart';
import '../../../../core/utils/xp_utils.dart';

final priceDataProvider =
    FutureProvider.family<GePriceData?, String>((ref, itemId) async {
  final apiService = GeApiService();
  return apiService.getItemPriceData(int.parse(itemId));
});

class PriceGraphPage extends ConsumerWidget {
  final String itemId;

  const PriceGraphPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceDataAsync = ref.watch(priceDataProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Graph'),
      ),
      body: priceDataAsync.when(
        data: (priceData) {
          if (priceData == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 64),
                  SizedBox(height: 16),
                  Text('Price data unavailable'),
                  SizedBox(height: 8),
                  Text('This feature requires internet connection'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Price Card
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Price'),
                        const SizedBox(height: 8),
                        Text(
                          '${XpUtils.formatGp(priceData.currentPrice)} GP',
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

                // Price Changes
                Row(
                  children: [
                    Expanded(
                      child: _ChangeCard(
                        title: '24h',
                        change: priceData.change24h,
                        percent: priceData.change24hPercent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ChangeCard(
                        title: '7d',
                        change: priceData.change7d,
                        percent: priceData.change7dPercent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ChangeCard(
                        title: '30d',
                        change: priceData.change30d,
                        percent: priceData.change30dPercent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Price Graph
                if (priceData.priceHistory.isNotEmpty) ...[
                  Text(
                    'Price History (24h)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: priceData.priceHistory
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                      e.key.toDouble(),
                                      e.value.price.toDouble(),
                                    ))
                                .toList(),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              const Text('Failed to load price data'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(priceDataProvider(itemId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChangeCard extends StatelessWidget {
  final String title;
  final int change;
  final double percent;

  const _ChangeCard({
    required this.title,
    required this.change,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 16,
            ),
            Text(
              '${isPositive ? '+' : ''}${XpUtils.formatGp(change)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${percent.toStringAsFixed(1)}%',
              style: TextStyle(color: color, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
