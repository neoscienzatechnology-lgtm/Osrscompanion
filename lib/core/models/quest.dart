class Quest {
  final String id;
  final String name;
  final String difficulty;
  final String length;
  final bool members;
  final bool combat;
  final int questPoints;
  final Map<String, dynamic> requirements;
  final Map<String, dynamic> rewards;
  final List<String> steps;

  Quest({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.length,
    required this.members,
    required this.combat,
    required this.questPoints,
    required this.requirements,
    required this.rewards,
    required this.steps,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String,
      name: json['name'] as String,
      difficulty: json['difficulty'] as String,
      length: json['length'] as String,
      members: json['members'] as bool,
      combat: json['combat'] as bool,
      questPoints: json['questPoints'] as int,
      requirements: json['requirements'] as Map<String, dynamic>,
      rewards: json['rewards'] as Map<String, dynamic>,
      steps: (json['steps'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'difficulty': difficulty,
      'length': length,
      'members': members,
      'combat': combat,
      'questPoints': questPoints,
      'requirements': requirements,
      'rewards': rewards,
      'steps': steps,
    };
  }
}
