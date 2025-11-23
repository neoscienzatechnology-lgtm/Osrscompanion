class XpGoal {
  final String id;
  final String skillId;
  final int currentLevel;
  final int targetLevel;
  final int currentXp;
  final int targetXp;
  final DateTime createdAt;
  final String? selectedMethod;

  XpGoal({
    required this.id,
    required this.skillId,
    required this.currentLevel,
    required this.targetLevel,
    required this.currentXp,
    required this.targetXp,
    required this.createdAt,
    this.selectedMethod,
  });

  int get xpNeeded => targetXp - currentXp;

  factory XpGoal.fromJson(Map<String, dynamic> json) {
    return XpGoal(
      id: json['id'] as String,
      skillId: json['skillId'] as String,
      currentLevel: json['currentLevel'] as int,
      targetLevel: json['targetLevel'] as int,
      currentXp: json['currentXp'] as int,
      targetXp: json['targetXp'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      selectedMethod: json['selectedMethod'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skillId': skillId,
      'currentLevel': currentLevel,
      'targetLevel': targetLevel,
      'currentXp': currentXp,
      'targetXp': targetXp,
      'createdAt': createdAt.toIso8601String(),
      'selectedMethod': selectedMethod,
    };
  }

  XpGoal copyWith({
    String? id,
    String? skillId,
    int? currentLevel,
    int? targetLevel,
    int? currentXp,
    int? targetXp,
    DateTime? createdAt,
    String? selectedMethod,
  }) {
    return XpGoal(
      id: id ?? this.id,
      skillId: skillId ?? this.skillId,
      currentLevel: currentLevel ?? this.currentLevel,
      targetLevel: targetLevel ?? this.targetLevel,
      currentXp: currentXp ?? this.currentXp,
      targetXp: targetXp ?? this.targetXp,
      createdAt: createdAt ?? this.createdAt,
      selectedMethod: selectedMethod ?? this.selectedMethod,
    );
  }
}
