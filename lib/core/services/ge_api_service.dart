import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ge_item.dart';

class GeApiService {
  static const String baseUrl = 'https://prices.runescape.wiki/api/v1/osrs';
  
  // Get latest prices for all items
  Future<Map<int, int>> getLatestPrices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/latest'),
        headers: {
          'User-Agent': 'OSRS Companion App - Price Tracker',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<int, int> prices = {};
        
        if (data['data'] != null) {
          final itemsData = data['data'] as Map<String, dynamic>;
          itemsData.forEach((key, value) {
            final itemId = int.tryParse(key);
            if (itemId != null && value['high'] != null) {
              prices[itemId] = value['high'] as int;
            }
          });
        }
        
        return prices;
      } else {
        throw Exception('Failed to load prices');
      }
    } catch (e) {
      print('Error fetching GE prices: $e');
      return {};
    }
  }

  // Get price data for a specific item
  Future<GePriceData?> getItemPriceData(int itemId) async {
    try {
      // Get current price
      final latestResponse = await http.get(
        Uri.parse('$baseUrl/latest'),
        headers: {
          'User-Agent': 'OSRS Companion App - Price Tracker',
        },
      );

      if (latestResponse.statusCode != 200) {
        return null;
      }

      final latestData = json.decode(latestResponse.body);
      final itemData = latestData['data']['$itemId'];
      
      if (itemData == null) {
        return null;
      }

      final currentPrice = itemData['high'] as int? ?? 0;

      // Get 5-minute price history for the last 24 hours
      final timespanResponse = await http.get(
        Uri.parse('$baseUrl/5m?id=$itemId'),
        headers: {
          'User-Agent': 'OSRS Companion App - Price Tracker',
        },
      );

      List<PricePoint> priceHistory = [];
      
      if (timespanResponse.statusCode == 200) {
        final timespanData = json.decode(timespanResponse.body);
        final data = timespanData['data'] as List?;
        
        if (data != null) {
          priceHistory = data.map((point) {
            return PricePoint(
              date: DateTime.fromMillisecondsSinceEpoch(point['timestamp'] * 1000),
              price: point['avgHighPrice'] as int? ?? 0,
            );
          }).toList();
        }
      }

      // Calculate price changes (simplified - using mock data if history unavailable)
      int change24h = 0;
      int change7d = 0;
      int change30d = 0;

      if (priceHistory.isNotEmpty) {
        // Find price 24h ago (approximately)
        final yesterday = DateTime.now().subtract(const Duration(hours: 24));
        final yesterdayPrice = priceHistory
            .where((p) => p.date.isBefore(yesterday))
            .lastOrNull
            ?.price ?? currentPrice;
        
        change24h = currentPrice - yesterdayPrice;
      }

      return GePriceData(
        itemId: itemId,
        currentPrice: currentPrice,
        change24h: change24h,
        change7d: change7d, // Would need longer history
        change30d: change30d, // Would need longer history
        priceHistory: priceHistory,
      );
    } catch (e) {
      print('Error fetching item price data: $e');
      return null;
    }
  }

  // Get mapping of item names to IDs
  Future<Map<String, int>> getItemMapping() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mapping'),
        headers: {
          'User-Agent': 'OSRS Companion App - Price Tracker',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final Map<String, int> mapping = {};
        
        for (var item in data) {
          mapping[item['name'] as String] = item['id'] as int;
        }
        
        return mapping;
      } else {
        throw Exception('Failed to load item mapping');
      }
    } catch (e) {
      print('Error fetching item mapping: $e');
      return {};
    }
  }
}

extension _IterableExtension<T> on Iterable<T> {
  T? get lastOrNull {
    if (isEmpty) return null;
    return last;
  }
}
