class Skill {
  final String id;
  final String name;
  final String icon;
  final String description;
  final bool members;
  final List<XpLevel> xpTable;
  final List<TrainingMethod> trainingMethods;

  Skill({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.members,
    required this.xpTable,
    required this.trainingMethods,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      members: json['members'] as bool,
      xpTable: (json['xpTable'] as List)
          .map((e) => XpLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
      trainingMethods: (json['trainingMethods'] as List)
          .map((e) => TrainingMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'members': members,
      'xpTable': xpTable.map((e) => e.toJson()).toList(),
      'trainingMethods': trainingMethods.map((e) => e.toJson()).toList(),
    };
  }
}

class XpLevel {
  final int level;
  final int xp;

  XpLevel({required this.level, required this.xp});

  factory XpLevel.fromJson(Map<String, dynamic> json) {
    return XpLevel(
      level: json['level'] as int,
      xp: json['xp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'xp': xp,
    };
  }
}

class TrainingMethod {
  final String levelRange;
  final String method;
  final int xpPerHour;
  final int gpCost;
  final List<String> items;

  TrainingMethod({
    required this.levelRange,
    required this.method,
    required this.xpPerHour,
    required this.gpCost,
    required this.items,
  });

  factory TrainingMethod.fromJson(Map<String, dynamic> json) {
    return TrainingMethod(
      levelRange: json['levelRange'] as String,
      method: json['method'] as String,
      xpPerHour: json['xpPerHour'] as int,
      gpCost: json['gpCost'] as int,
      items: (json['items'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelRange': levelRange,
      'method': method,
      'xpPerHour': xpPerHour,
      'gpCost': gpCost,
      'items': items,
    };
  }
}
