class AchievementModel {
  final int id;
  final String icon;
  final String title;
  final String description;
  final bool unlocked;

  AchievementModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'description': description,
      'unlocked': unlocked ? 1 : 0,
    };
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'],
      icon: map['icon'],
      title: map['title'],
      description: map['description'],
      unlocked: map['unlocked'] == 1,
    );
  }
}
