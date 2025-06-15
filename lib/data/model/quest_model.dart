enum QuestStatus { active, completed, failed }

extension QuestStatusExtension on QuestStatus {
  String get name {
    return toString().split('.').last;
  }

  String get label {
    switch (this) {
      case QuestStatus.completed:
        return 'Completed';
      case QuestStatus.failed:
        return 'Failed';
      case QuestStatus.active:
        return 'Active';
    }
  }

  static QuestStatus fromString(String status) {
    switch (status) {
      case 'completed':
        return QuestStatus.completed;
      case 'failed':
        return QuestStatus.failed;
      case 'active':
      default:
        return QuestStatus.active;
    }
  }
}

class Quest {
  int? id;
  String title;
  String description;
  int pointsReward;
  DateTime? deadlineDateTime;
  QuestStatus status;

  Quest({
    this.id,
    required this.title,
    required this.description,
    required this.pointsReward,
    this.deadlineDateTime,
    this.status = QuestStatus.active,
  });

  Quest copyWith({
    int? id,
    String? title,
    String? description,
    int? pointsReward,
    DateTime? deadlineDateTime,
    QuestStatus? status,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsReward: pointsReward ?? this.pointsReward,
      deadlineDateTime: deadlineDateTime ?? this.deadlineDateTime,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointsReward': pointsReward,
      'deadlineDateTime': deadlineDateTime?.toIso8601String(),
      'status': status.name,
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      pointsReward: map['pointsReward'] as int,
      deadlineDateTime: map['deadlineDateTime'] != null
          ? DateTime.parse(map['deadlineDateTime'])
          : null,
      status: QuestStatusExtension.fromString(map['status'] as String),
    );
  }

  @override
  String toString() {
    return 'Quest{id: $id, title: "$title", description: "$description", pointsReward: $pointsReward, deadlineDateTime: $deadlineDateTime, status: ${status.name}}';
  }
}
