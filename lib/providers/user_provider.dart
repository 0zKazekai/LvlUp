import 'package:flutter/material.dart';
import '../entities/user_stats.dart';
import 'quest_provider.dart';

class UserProvider extends ChangeNotifier {
  UserStats _userStats;

  UserProvider() : _userStats = UserStats(
    userId: 'current_user',
    username: 'Player',
    title: 'Awakened',
    level: 12,
    currentXP: 325,
    xpToNextLevel: 400,
    str: 14,
    vit: 12,
    intel: 16,
    cha: 11,
    maxStat: 20,
    questsCompleted: 23,
    currentStreak: 5,
    longestStreak: 12,
    arcFocus: 'Balanced',
    achievements: [],
    followers: 127,
    following: 89,
    isPrivate: false,
  );

  UserStats get userStats => _userStats;

  void addXP(int amount) {
    _userStats.addXP(amount);
    notifyListeners();
  }

  void addStat(String key, int amount) {
    _userStats.addStat(key, amount);
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    _userStats = _userStats.copyWith(username: newUsername);
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    _userStats = _userStats.copyWith(title: newTitle);
    notifyListeners();
  }

  void updateAvatar(String? avatarUrl) {
    _userStats = _userStats.copyWith(avatarUrl: avatarUrl);
    notifyListeners();
  }

  void updatePrivacy(bool isPrivate) {
    _userStats = _userStats.copyWith(isPrivate: isPrivate);
    notifyListeners();
  }

  void updateFollowers(int count) {
    _userStats = _userStats.copyWith(followers: count);
    notifyListeners();
  }

  void updateFollowing(int count) {
    _userStats = _userStats.copyWith(following: count);
    notifyListeners();
  }

  void completeQuest(Quest quest) {
    // Add XP from quest
    addXP(quest.xpReward);
    
    // Increment quests completed
    _userStats = _userStats.copyWith(
      questsCompleted: _userStats.questsCompleted + 1,
    );
    
    // Increment streak
    incrementStreak();
    
    // Add stat rewards
    if (quest.statRewards.isNotEmpty) {
      for (final reward in quest.statRewards.entries) {
        addStat(reward.key, reward.value);
      }
    }
    
    // Check for new achievements
    _checkAchievements();
    
    notifyListeners();
  }

  void incrementStreak() {
    final newStreak = _userStats.currentStreak + 1;
    _userStats = _userStats.copyWith(
      currentStreak: newStreak,
      longestStreak: newStreak > _userStats.longestStreak ? newStreak : _userStats.longestStreak,
    );
    notifyListeners();
  }

  void resetStreak() {
    _userStats = _userStats.copyWith(currentStreak: 0);
    notifyListeners();
  }

  void updateArcFocus(String newArcFocus) {
    _userStats = _userStats.copyWith(arcFocus: newArcFocus);
    notifyListeners();
  }

  void addAchievement(String achievement) {
    if (!_userStats.achievements.contains(achievement)) {
      final newAchievements = List<String>.from(_userStats.achievements)
        ..add(achievement);
      _userStats = _userStats.copyWith(achievements: newAchievements);
      notifyListeners();
    }
  }

  void _checkAchievements() {
    // Level achievements
    if (_userStats.level >= 5 && !_userStats.achievements.contains('Rising Star')) {
      addAchievement('Rising Star');
    }
    if (_userStats.level >= 10 && !_userStats.achievements.contains('Seasoned Hero')) {
      addAchievement('Seasoned Hero');
    }
    if (_userStats.level >= 20 && !_userStats.achievements.contains('Legendary')) {
      addAchievement('Legendary');
    }

    // Streak achievements
    if (_userStats.currentStreak >= 7 && !_userStats.achievements.contains('Week Warrior')) {
      addAchievement('Week Warrior');
    }
    if (_userStats.currentStreak >= 30 && !_userStats.achievements.contains('Monthly Master')) {
      addAchievement('Monthly Master');
    }

    // Quest achievements
    if (_userStats.questsCompleted >= 10 && !_userStats.achievements.contains('Quest Initiate')) {
      addAchievement('Quest Initiate');
    }
    if (_userStats.questsCompleted >= 50 && !_userStats.achievements.contains('Quest Master')) {
      addAchievement('Quest Master');
    }

    // Stat achievements
    if (_userStats.statsMap.values.any((stat) => stat >= 15) && !_userStats.achievements.contains('Stat Specialist')) {
      addAchievement('Stat Specialist');
    }
    if (_userStats.statsMap.values.every((stat) => stat >= 10) && !_userStats.achievements.contains('Balanced Build')) {
      addAchievement('Balanced Build');
    }
  }

  // Helper method to get XP progress
  double get xpProgress => _userStats.currentXP / _userStats.xpToNextLevel;

  // Helper method to get total stats
  int get totalStats => _userStats.str + _userStats.vit + _userStats.intel + _userStats.cha;

  // Helper method to check if user can level up
  bool get canLevelUp => _userStats.currentXP >= _userStats.xpToNextLevel;
}

