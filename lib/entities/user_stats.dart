class UserStats {
  final String userId;
  String username;
  String title;
  int level;
  int currentXP;
  int xpToNextLevel;
  int str;
  int vit;
  int intel;
  int cha;
  final int maxStat;
  int questsCompleted;
  int currentStreak;
  int longestStreak;
  String arcFocus;
  List<String> achievements;
  String? avatarUrl;
  int followers;
  int following;
  bool isPrivate;

  UserStats({
    required this.userId,
    required this.username,
    this.title = 'Awakened',
    this.level = 1,
    this.currentXP = 0,
    this.xpToNextLevel = 100,
    this.str = 5,
    this.vit = 5,
    this.intel = 5,
    this.cha = 5,
    this.maxStat = 20,
    this.questsCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.arcFocus = 'Balanced',
    this.achievements = const [],
    this.avatarUrl,
    this.followers = 0,
    this.following = 0,
    this.isPrivate = false,
  });

  void addXP(int amount) {
    currentXP += amount;
    
    // Handle leveling up
    while (currentXP >= xpToNextLevel) {
      currentXP -= xpToNextLevel;
      level++;
      xpToNextLevel = _calculateXPForNextLevel(level);
      
      // Add stat points on level up
      // You could give 1-2 stat points per level here
    }
  }

  void addStat(String key, int amount) {
    switch (key.toLowerCase()) {
      case 'str':
      case 'strength':
        str = (str + amount).clamp(0, maxStat);
        break;
      case 'vit':
      case 'vitality':
        vit = (vit + amount).clamp(0, maxStat);
        break;
      case 'int':
      case 'intel':
      case 'intelligence':
        intel = (intel + amount).clamp(0, maxStat);
        break;
      case 'cha':
      case 'charisma':
        cha = (cha + amount).clamp(0, maxStat);
        break;
    }
  }

  Map<String, int> get statsMap => {
    'str': str,
    'vit': vit,
    'intel': intel,
    'cha': cha,
  };

  int _calculateXPForNextLevel(int level) {
    // Exponential growth formula: 100 * (1.2 ^ (level - 1))
    return (100 * (1.2 * (level - 1))).round();
  }

  UserStats copyWith({
    String? userId,
    String? username,
    String? title,
    int? level,
    int? currentXP,
    int? xpToNextLevel,
    int? str,
    int? vit,
    int? intel,
    int? cha,
    int? maxStat,
    int? questsCompleted,
    int? currentStreak,
    int? longestStreak,
    String? arcFocus,
    List<String>? achievements,
    String? avatarUrl,
    int? followers,
    int? following,
    bool? isPrivate,
  }) {
    return UserStats(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      title: title ?? this.title,
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      str: str ?? this.str,
      vit: vit ?? this.vit,
      intel: intel ?? this.intel,
      cha: cha ?? this.cha,
      maxStat: maxStat ?? this.maxStat,
      questsCompleted: questsCompleted ?? this.questsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      arcFocus: arcFocus ?? this.arcFocus,
      achievements: achievements ?? this.achievements,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
