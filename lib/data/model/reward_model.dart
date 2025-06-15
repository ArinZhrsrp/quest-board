class Reward {
  final int? id;
  final String title;
  final String description;
  final int pointsCost;
  final int iconIndex;
  final int status; // 0 = not redeemed, 1 = redeemed

  Reward({
    this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.iconIndex,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointsCost': pointsCost,
      'iconIndex': iconIndex,
      'status': status,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      pointsCost: map['pointsCost'],
      iconIndex: map['iconIndex'],
      status: map['status'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Reward{id: $id, title: "$title", description: "$description", pointsCost: $pointsCost, iconIndex: $iconIndex, status: $status}';
  }
}
