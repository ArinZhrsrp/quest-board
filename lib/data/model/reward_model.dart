enum RewardStatus { available, claimed }

extension RewardStatusExtension on RewardStatus {
  String get label {
    switch (this) {
      case RewardStatus.claimed:
        return 'Claimed';
      case RewardStatus.available:
        return 'Available';
    }
  }

  static RewardStatus fromInt(int value) {
    switch (value) {
      case 1:
        return RewardStatus.claimed;
      case 0:
      default:
        return RewardStatus.available;
    }
  }

  int get toInt {
    switch (this) {
      case RewardStatus.claimed:
        return 1;
      case RewardStatus.available:
        return 0;
    }
  }
}

class Reward {
  final int? id;
  final String title;
  final String description;
  final int pointsCost;
  final int iconIndex;
  final RewardStatus status;

  Reward({
    this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.iconIndex,
    this.status = RewardStatus.available,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointsCost': pointsCost,
      'iconIndex': iconIndex,
      'status': status.toInt,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      pointsCost: map['pointsCost'],
      iconIndex: map['iconIndex'],
      status: RewardStatusExtension.fromInt(map['status'] ?? 0),
    );
  }

  @override
  String toString() {
    return 'Reward{id: $id, title: "$title", description: "$description", pointsCost: $pointsCost, iconIndex: $iconIndex, status: ${status.label}}';
  }
}
