class GeItem {
  final int id;
  final String name;
  final int price;
  final int highAlch;
  final int lowAlch;
  final bool members;

  GeItem({
    required this.id,
    required this.name,
    required this.price,
    required this.highAlch,
    required this.lowAlch,
    required this.members,
  });

  factory GeItem.fromJson(Map<String, dynamic> json) {
    return GeItem(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      highAlch: json['high_alch'] as int,
      lowAlch: json['low_alch'] as int,
      members: json['members'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'high_alch': highAlch,
      'low_alch': lowAlch,
      'members': members,
    };
  }
}

class GePriceData {
  final int itemId;
  final int currentPrice;
  final int change24h;
  final int change7d;
  final int change30d;
  final List<PricePoint> priceHistory;

  GePriceData({
    required this.itemId,
    required this.currentPrice,
    required this.change24h,
    required this.change7d,
    required this.change30d,
    required this.priceHistory,
  });

  double get change24hPercent => (change24h / currentPrice) * 100;
  double get change7dPercent => (change7d / currentPrice) * 100;
  double get change30dPercent => (change30d / currentPrice) * 100;
}

class PricePoint {
  final DateTime date;
  final int price;

  PricePoint({required this.date, required this.price});
}
