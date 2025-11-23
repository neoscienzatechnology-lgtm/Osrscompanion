class MoneyMethod {
  final String id;
  final String name;
  final String category;
  final int gpPerHour;
  final Map<String, dynamic> requirements;
  final String difficulty;
  final String description;
  final List<String> steps;
  final List<String> items;

  MoneyMethod({
    required this.id,
    required this.name,
    required this.category,
    required this.gpPerHour,
    required this.requirements,
    required this.difficulty,
    required this.description,
    required this.steps,
    required this.items,
  });

  factory MoneyMethod.fromJson(Map<String, dynamic> json) {
    return MoneyMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      gpPerHour: json['gpPerHour'] as int,
      requirements: json['requirements'] as Map<String, dynamic>,
      difficulty: json['difficulty'] as String,
      description: json['description'] as String,
      steps: (json['steps'] as List).map((e) => e as String).toList(),
      items: (json['items'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'gpPerHour': gpPerHour,
      'requirements': requirements,
      'difficulty': difficulty,
      'description': description,
      'steps': steps,
      'items': items,
    };
  }
}
