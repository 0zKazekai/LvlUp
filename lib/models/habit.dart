import 'dart:convert';

class Habit {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final int targetFrequency; // Times per week
  final int currentStreak;
  final int longestStreak;
  final int xpReward;
  final List<String> statRewards;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.targetFrequency,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.xpReward = 10,
    this.statRewards = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      targetFrequency: json['target_frequency'] as int,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      xpReward: json['xp_reward'] as int? ?? 10,
      statRewards: (json['stat_rewards'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'target_frequency': targetFrequency,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'xp_reward': xpReward,
      'stat_rewards': statRewards,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Copy with method
  Habit copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    int? targetFrequency,
    int? currentStreak,
    int? longestStreak,
    int? xpReward,
    List<String>? statRewards,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetFrequency: targetFrequency ?? this.targetFrequency,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      xpReward: xpReward ?? this.xpReward,
      statRewards: statRewards ?? this.statRewards,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, category: $category, streak: $currentStreak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit &&
        other.id == id &&
        other.userId == userId &&
        other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ title.hashCode;
}

class HabitCompletion {
  final String id;
  final String habitId;
  final String userId;
  final DateTime completedAt;
  final String? notes;
  final String? proofImagePath;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.completedAt,
    this.notes,
    this.proofImagePath,
  });

  // JSON serialization
  factory HabitCompletion.fromJson(Map<String, dynamic> json) {
    return HabitCompletion(
      id: json['id'] as String,
      habitId: json['habit_id'] as String,
      userId: json['user_id'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
      notes: json['notes'] as String?,
      proofImagePath: json['proof_image_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'completed_at': completedAt.toIso8601String(),
      'notes': notes,
      'proof_image_path': proofImagePath,
    };
  }

  @override
  String toString() {
    return 'HabitCompletion(habitId: $habitId, completedAt: $completedAt)';
  }
}
