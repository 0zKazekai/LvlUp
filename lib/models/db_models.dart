class UserStatRecord {
  final String id;
  final String userId;
  final String statType;
  final int value;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserStatRecord({
    required this.id,
    required this.userId,
    required this.statType,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserStatRecord.fromJson(Map<String, dynamic> json) {
    return UserStatRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      statType: json['stat_type'] as String,
      value: json['value'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'stat_type': statType,
        'value': value,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class UserQuestRecord {
  final String id;
  final String userId;
  final String questId;
  final String status;
  final int progress;
  final int maxProgress;
  final String? proofUrl;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserQuestRecord({
    required this.id,
    required this.userId,
    required this.questId,
    required this.status,
    required this.progress,
    required this.maxProgress,
    this.proofUrl,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserQuestRecord.fromJson(Map<String, dynamic> json) {
    return UserQuestRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      questId: json['quest_id'] as String,
      status: json['status'] as String? ?? 'pending',
      progress: json['progress'] as int? ?? 0,
      maxProgress: json['max_progress'] as int? ?? 1,
      proofUrl: json['proof_url'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'quest_id': questId,
        'status': status,
        'progress': progress,
        'max_progress': maxProgress,
        'proof_url': proofUrl,
        'completed_at': completedAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class Achievement {
  final String id;
  final String title;
  final String? description;
  final String? icon;
  final String requirementType;
  final int requirementValue;
  final int rewardXp;
  final DateTime createdAt;

  const Achievement({
    required this.id,
    required this.title,
    this.description,
    this.icon,
    required this.requirementType,
    required this.requirementValue,
    required this.rewardXp,
    required this.createdAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      requirementType: json['requirement_type'] as String,
      requirementValue: json['requirement_value'] as int,
      rewardXp: json['reward_xp'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
        'requirement_type': requirementType,
        'requirement_value': requirementValue,
        'reward_xp': rewardXp,
        'created_at': createdAt.toIso8601String(),
      };
}

class UserAchievement {
  final String id;
  final String userId;
  final String achievementId;
  final DateTime unlockedAt;

  const UserAchievement({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      achievementId: json['achievement_id'] as String,
      unlockedAt: DateTime.parse(json['unlocked_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'achievement_id': achievementId,
        'unlocked_at': unlockedAt.toIso8601String(),
      };
}

class FeedItem {
  final String id;
  final String userId;
  final String content;
  final String feedType;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const FeedItem({
    required this.id,
    required this.userId,
    required this.content,
    required this.feedType,
    required this.metadata,
    required this.createdAt,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      feedType: json['feed_type'] as String,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'content': content,
        'feed_type': feedType,
        'metadata': metadata,
        'created_at': createdAt.toIso8601String(),
      };
}
