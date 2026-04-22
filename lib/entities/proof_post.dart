class ProofPost {
  final String id;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String questTitle;
  final String questArc;
  final String questRank;
  final String imagePath;
  final String caption;
  final int xpEarned;
  final int likes;
  final DateTime createdAt;
  final bool isLikedByMe;

  ProofPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.questTitle,
    required this.questArc,
    required this.questRank,
    required this.imagePath,
    required this.caption,
    required this.xpEarned,
    required this.likes,
    required this.createdAt,
    required this.isLikedByMe,
  });

  static List<ProofPost> samples() {
    return [
      ProofPost(
        id: '1',
        userId: 'user1',
        userName: 'DragonSlayer99',
        userAvatarUrl: 'assets/avatars/avatar1.png',
        questTitle: 'Morning Meditation',
        questArc: 'Mind',
        questRank: 'B',
        imagePath: 'assets/posts/meditation1.jpg',
        caption: 'Started my day with 20 minutes of mindfulness meditation. Feeling centered and ready to conquer the day! #Mindfulness #DailyGrind',
        xpEarned: 50,
        likes: 24,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isLikedByMe: false,
      ),
      ProofPost(
        id: '2',
        userId: 'user2',
        userName: 'ShadowNinja',
        userAvatarUrl: 'assets/avatars/avatar2.png',
        questTitle: '5K Run',
        questArc: 'Body',
        questRank: 'A',
        imagePath: 'assets/posts/running1.jpg',
        caption: 'Crushed my personal best! 5K in 22 minutes. The grind never stops! #Fitness #Endurance',
        xpEarned: 75,
        likes: 45,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isLikedByMe: true,
      ),
      ProofPost(
        id: '3',
        userId: 'user3',
        userName: 'MysticMage',
        userAvatarUrl: 'assets/avatars/avatar3.png',
        questTitle: 'Code Review Session',
        questArc: 'Skills',
        questRank: 'S',
        imagePath: 'assets/posts/coding1.jpg',
        caption: 'Completed a comprehensive code review for the team. Found 3 critical bugs and suggested optimizations. Level up! #Coding #TeamWork',
        xpEarned: 100,
        likes: 67,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isLikedByMe: false,
      ),
    ];
  }
}
