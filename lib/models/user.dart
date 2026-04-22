import 'dart:convert';

class User {
  final String id;
  final String email;
  final String username;
  final String title;
  final int level;
  final int currentXP;
  final int xpToNextLevel;
  final int str;
  final int vit;
  final int intel;
  final int cha;
  final int questsCompleted;
  final int currentStreak;
  final int longestStreak;
  final String arcFocus;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.title = 'Awakened',
    this.level = 1,
    this.currentXP = 0,
    this.xpToNextLevel = 100,
    this.str = 5,
    this.vit = 5,
    this.intel = 5,
    this.cha = 5,
    this.questsCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.arcFocus = 'Balanced',
    this.achievements = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      title: json['title'] as String? ?? 'Awakened',
      level: json['level'] as int? ?? 1,
      currentXP: json['current_xp'] as int? ?? 0,
      xpToNextLevel: json['xp_to_next_level'] as int? ?? 100,
      str: json['str'] as int? ?? 5,
      vit: json['vit'] as int? ?? 5,
      intel: json['intel'] as int? ?? 5,
      cha: json['cha'] as int? ?? 5,
      questsCompleted: json['quests_completed'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      arcFocus: json['arc_focus'] as String? ?? 'Balanced',
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'title': title,
      'level': level,
      'current_xp': currentXP,
      'xp_to_next_level': xpToNextLevel,
      'str': str,
      'vit': vit,
      'intel': intel,
      'cha': cha,
      'quests_completed': questsCompleted,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'arc_focus': arcFocus,
      'achievements': achievements,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Copy with method
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? title,
    int? level,
    int? currentXP,
    int? xpToNextLevel,
    int? str,
    int? vit,
    int? intel,
    int? cha,
    int? questsCompleted,
    int? currentStreak,
    int? longestStreak,
    String? arcFocus,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      title: title ?? this.title,
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      str: str ?? this.str,
      vit: vit ?? this.vit,
      intel: intel ?? this.intel,
      cha: cha ?? this.cha,
      questsCompleted: questsCompleted ?? this.questsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      arcFocus: arcFocus ?? this.arcFocus,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, level: $level, xp: $currentXP/$xpToNextLevel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ username.hashCode;
}
