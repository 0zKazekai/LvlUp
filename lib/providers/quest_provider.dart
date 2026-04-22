import 'package:flutter/material.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final String arc;
  final String rank;
  final int xpReward;
  final Map<String, int> statRewards;
  final bool isCompleted;
  final DateTime? completedAt;
  final bool isDaily;
  final DateTime? availableUntil;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.arc,
    required this.rank,
    required this.xpReward,
    this.statRewards = const {},
    this.isCompleted = false,
    this.completedAt,
    this.isDaily = false,
    this.availableUntil,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      arc: json['arc'] as String,
      rank: json['rank'] as String? ?? 'C',
      xpReward: json['xp_reward'] as int? ?? 10,
      statRewards: (json['stat_rewards'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          {},
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      isDaily: json['is_daily'] as bool? ?? false,
      availableUntil: json['available_until'] != null
          ? DateTime.parse(json['available_until'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'arc': arc,
      'rank': rank,
      'xp_reward': xpReward,
      'stat_rewards': statRewards,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'is_daily': isDaily,
      'available_until': availableUntil?.toIso8601String(),
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    String? arc,
    String? rank,
    int? xpReward,
    Map<String, int>? statRewards,
    bool? isCompleted,
    DateTime? completedAt,
    bool? isDaily,
    DateTime? availableUntil,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      arc: arc ?? this.arc,
      rank: rank ?? this.rank,
      xpReward: xpReward ?? this.xpReward,
      statRewards: statRewards ?? this.statRewards,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isDaily: isDaily ?? this.isDaily,
      availableUntil: availableUntil ?? this.availableUntil,
    );
  }
}

class QuestProvider extends ChangeNotifier {
  List<Quest> _quests = [];

  QuestProvider() {
    _initializeQuests();
  }

  List<Quest> get quests => _quests;

  // Get today's quests (daily quests + available quests)
  List<Quest> get todaysQuests {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _quests.where((quest) {
      // Include daily quests
      if (quest.isDaily) {
        // Reset daily quests if they were completed yesterday
        if (quest.completedAt != null) {
          final completedDate = DateTime(
            quest.completedAt!.year,
            quest.completedAt!.month,
            quest.completedAt!.day,
          );
          return completedDate.isAtSameMomentAs(today) || !quest.isCompleted;
        }
        return true;
      }
      
      // Include quests that are available and not expired
      if (quest.availableUntil != null) {
        return !quest.isCompleted && quest.availableUntil!.isAfter(now);
      }
      
      // Include regular quests that aren't completed
      return !quest.isCompleted;
    }).toList();
  }

  // Get completed quests count
  int get completedCount => _quests.where((quest) => quest.isCompleted).length;

  // Get total quests count
  int get totalCount => _quests.length;

  // Get quests by arc
  List<Quest> getQuestsByArc(String arc) {
    return _quests.where((quest) => quest.arc.toLowerCase() == arc.toLowerCase()).toList();
  }

  // Get quests by rank
  List<Quest> getQuestsByRank(String rank) {
    return _quests.where((quest) => quest.rank.toUpperCase() == rank.toUpperCase()).toList();
  }

  // Get daily quests
  List<Quest> get dailyQuests {
    return _quests.where((quest) => quest.isDaily).toList();
  }

  // Complete a quest
  void completeQuest(String questId, {String? proofPath}) {
    final questIndex = _quests.indexWhere((quest) => quest.id == questId);
    if (questIndex != -1) {
      final quest = _quests[questIndex];
      _quests[questIndex] = quest.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Reset daily quests (call this at midnight)
  void resetDailyQuests() {
    _quests = _quests.map((quest) {
      if (quest.isDaily) {
        return quest.copyWith(
          isCompleted: false,
          completedAt: null,
        );
      }
      return quest;
    }).toList();
    notifyListeners();
  }

  // Add new quest
  void addQuest(Quest quest) {
    _quests.add(quest);
    notifyListeners();
  }

  // Remove quest
  void removeQuest(String questId) {
    _quests.removeWhere((quest) => quest.id == questId);
    notifyListeners();
  }

  // Update quest
  void updateQuest(Quest updatedQuest) {
    final index = _quests.indexWhere((quest) => quest.id == updatedQuest.id);
    if (index != -1) {
      _quests[index] = updatedQuest;
      notifyListeners();
    }
  }

  // Get quest by ID
  Quest? getQuestById(String questId) {
    try {
      return _quests.firstWhere((quest) => quest.id == questId);
    } catch (e) {
      return null;
    }
  }

  // Get available quest count
  int get availableQuestCount => todaysQuests.length;

  // Get completion rate
  double get completionRate {
    if (totalCount == 0) return 0.0;
    return completedCount / totalCount;
  }

  // Initialize with sample quests
  void _initializeQuests() {
    _quests = [
      // Daily Quests
      Quest(
        id: 'daily_1',
        title: 'Morning Meditation',
        description: 'Start your day with 10 minutes of mindfulness meditation',
        arc: 'Mind',
        rank: 'C',
        xpReward: 25,
        statRewards: {'intel': 1},
        isDaily: true,
      ),
      Quest(
        id: 'daily_2',
        title: 'Physical Exercise',
        description: 'Complete 20 minutes of physical activity',
        arc: 'Body',
        rank: 'C',
        xpReward: 30,
        statRewards: {'vit': 1, 'str': 1},
        isDaily: true,
      ),
      Quest(
        id: 'daily_3',
        title: 'Read for 15 Minutes',
        description: 'Read a book or educational content for at least 15 minutes',
        arc: 'Mind',
        rank: 'C',
        xpReward: 20,
        statRewards: {'intel': 1},
        isDaily: true,
      ),

      // Weekly Quests
      Quest(
        id: 'weekly_1',
        title: 'Complete a Project',
        description: 'Finish a personal or work project this week',
        arc: 'Skills',
        rank: 'B',
        xpReward: 100,
        statRewards: {'intel': 2, 'cha': 1},
        availableUntil: DateTime.now().add(const Duration(days: 7)),
      ),
      Quest(
        id: 'weekly_2',
        title: 'Social Connection',
        description: 'Have a meaningful conversation with someone new',
        arc: 'Social',
        rank: 'B',
        xpReward: 75,
        statRewards: {'cha': 2},
        availableUntil: DateTime.now().add(const Duration(days: 7)),
      ),

      // Main Quests
      Quest(
        id: 'main_1',
        title: 'Learn a New Skill',
        description: 'Spend 5 hours learning a new skill or hobby',
        arc: 'Skills',
        rank: 'A',
        xpReward: 150,
        statRewards: {'intel': 3, 'str': 1},
      ),
      Quest(
        id: 'main_2',
        title: 'Fitness Challenge',
        description: 'Complete a 30-day fitness challenge',
        arc: 'Body',
        rank: 'A',
        xpReward: 200,
        statRewards: {'vit': 3, 'str': 2},
      ),
      Quest(
        id: 'main_3',
        title: 'Mindfulness Master',
        description: 'Meditate for 30 consecutive days',
        arc: 'Mind',
        rank: 'S',
        xpReward: 300,
        statRewards: {'intel': 4, 'vit': 1},
      ),
    ];
  }

  // Get quest statistics
  Map<String, int> get questStats {
    final stats = <String, int>{};
    for (final quest in _quests) {
      if (quest.isCompleted) {
        stats[quest.arc] = (stats[quest.arc] ?? 0) + 1;
      }
    }
    return stats;
  }

  // Get total XP earned from completed quests
  int get totalXPEarned {
    return _quests
        .where((quest) => quest.isCompleted)
        .fold(0, (sum, quest) => sum + quest.xpReward);
  }
}
