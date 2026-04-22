import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/user_provider.dart';
import '../widgets/common/xp_bar.dart';
import '../widgets/common/stat_bar.dart';
import '../widgets/common/achievement_badge.dart';
import '../widgets/proof/proof_timeline.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isPrivate = false;

  final List<AchievementInfo> _sampleAchievements = const [
    AchievementInfo(
      label: 'First Quest',
      emoji: ' ',
      color: AppColors.rankC,
      unlocked: true,
    ),
    AchievementInfo(
      label: 'Week Warrior',
      emoji: ' ',
      color: AppColors.rankB,
      unlocked: true,
    ),
    AchievementInfo(
      label: 'Stat Master',
      emoji: ' ',
      color: AppColors.rankA,
      unlocked: false,
    ),
    AchievementInfo(
      label: 'Social Butterfly',
      emoji: ' ',
      color: AppColors.statCha,
      unlocked: false,
    ),
    AchievementInfo(
      label: 'Level 10',
      emoji: ' ',
      color: AppColors.rankS,
      unlocked: false,
    ),
    AchievementInfo(
      label: 'Perfect Week',
      emoji: ' ',
      color: AppColors.rankD,
      unlocked: true,
    ),
  ];

  // Sample proof data for demonstration
  final List<ProofItem> _sampleProofs = [
    ProofItem(
      id: '1',
      questName: 'Morning Meditation',
      thumbnailUrl: 'https://picsum.photos/seed/meditation/400/300.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isVideo: false,
      xpEarned: 25,
    ),
    ProofItem(
      id: '2',
      questName: 'Exercise Session',
      thumbnailUrl: 'https://picsum.photos/seed/workout/400/300.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isVideo: false,
      xpEarned: 50,
    ),
    ProofItem(
      id: '3',
      questName: 'Read a Book',
      thumbnailUrl: 'https://picsum.photos/seed/reading/400/300.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isVideo: true,
      xpEarned: 30,
    ),
    ProofItem(
      id: '4',
      questName: 'Healthy Meal',
      thumbnailUrl: 'https://picsum.photos/seed/meal/400/300.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isVideo: false,
      xpEarned: 20,
    ),
    ProofItem(
      id: '5',
      questName: 'Social Connection',
      thumbnailUrl: 'https://picsum.photos/seed/social/400/300.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isVideo: false,
      xpEarned: 40,
    ),
  ];

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Avatar',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildAvatarOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null && mounted) {
        // TODO: Upload image to storage and update user profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update avatar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildAvatarOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.cyan.withValues(alpha:0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.cyan,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountCard({
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha:0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: AppTextStyles.h3.copyWith(
                color: AppColors.cyan,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isPrivate ? AppColors.error.withValues(alpha:0.2) : AppColors.success.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isPrivate ? AppColors.error.withValues(alpha:0.5) : AppColors.success.withValues(alpha:0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isPrivate ? Icons.lock : Icons.public,
            size: 16,
            color: _isPrivate ? AppColors.error : AppColors.success,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _isPrivate = !_isPrivate;
              });
              // TODO: Update user_stats table with is_private field
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isPrivate ? 'Profile set to private' : 'Profile set to public'),
                  backgroundColor: _isPrivate ? AppColors.error : AppColors.success,
                ),
              );
            },
            child: Text(
              _isPrivate ? 'Private' : 'Public',
              style: AppTextStyles.label.copyWith(
                color: _isPrivate ? AppColors.error : AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final userStats = userProvider.userStats;
          
          return CustomScrollView(
            slivers: [
              // Hero section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.surface,
                        AppColors.bg,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar with level badge
                      GestureDetector(
                        onTap: () => _showAvatarOptions(),
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.cyan.withValues(alpha:0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.cyan.withValues(alpha:0.5),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cyan.withValues(alpha:0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Container(
                                  color: AppColors.surface,
                                  child: userStats.avatarUrl != null
                                      ? Image.network(
                                          userStats.avatarUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 40,
                                              color: AppColors.textSecondary,
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 40,
                                          color: AppColors.textSecondary,
                                        ),
                                ),
                              ),
                            ),
                            // Camera icon overlay
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.cyan,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.bg,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            // Level badge
                            Positioned(
                              top: -5,
                              right: -5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.cyan,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.bg,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  'LV${userStats.level}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Username and title
                      Text(
                        userStats.username,
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userStats.title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Streak counter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.rankD.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.rankD.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              ' ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${userStats.currentStreak} Day Streak',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.rankD,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Followers / Following counts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCountCard(
                            label: 'Followers',
                            count: userStats.followers,
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          _buildCountCard(
                            label: 'Following',
                            count: userStats.following,
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Privacy toggle
                      _buildPrivacyToggle(),
                    ],
                  ),
                ),
              ),

              // XPBar widget
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: XPBar(
                    level: userStats.level,
                    currentXP: userStats.currentXP,
                    maxXP: userStats.xpToNextLevel,
                    animate: true,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Stats section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'CHARACTER STATS',
                    style: AppTextStyles.sectionHeader.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // 4 StatBar widgets
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha:0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      StatBar(
                        label: 'STRENGTH',
                        value: userStats.str,
                        max: userStats.maxStat,
                        color: AppColors.statStr,
                      ),
                      const SizedBox(height: 12),
                      StatBar(
                        label: 'VITALITY',
                        value: userStats.vit,
                        max: userStats.maxStat,
                        color: AppColors.statVit,
                      ),
                      const SizedBox(height: 12),
                      StatBar(
                        label: 'INTELLIGENCE',
                        value: userStats.intel,
                        max: userStats.maxStat,
                        color: AppColors.statInt,
                      ),
                      const SizedBox(height: 12),
                      StatBar(
                        label: 'CHARISMA',
                        value: userStats.cha,
                        max: userStats.maxStat,
                        color: AppColors.statCha,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Achievements section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ACHIEVEMENTS',
                    style: AppTextStyles.sectionHeader.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Achievements grid
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha:0.2),
                      width: 1,
                    ),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _sampleAchievements.length,
                    itemBuilder: (context, index) {
                      final achievement = _sampleAchievements[index];
                      return AchievementBadge(
                        label: achievement.label,
                        emoji: achievement.emoji,
                        color: achievement.color,
                        unlocked: achievement.unlocked,
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Proof Timeline section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProofTimeline(proofs: _sampleProofs),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Stats summary section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha:0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROGRESS SUMMARY',
                        style: AppTextStyles.sectionHeader.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow('Quests Completed', '${userStats.questsCompleted}'),
                      _buildSummaryRow('Longest Streak', '${userStats.longestStreak} days'),
                      _buildSummaryRow('Arc Focus', userStats.arcFocus),
                      _buildSummaryRow('Total Stats', '${userProvider.totalStats}'),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Settings section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha:0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'SETTINGS',
                          style: AppTextStyles.sectionHeader.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _buildSettingsTile(
                        icon: Icons.person,
                        title: 'Edit Profile',
                        onTap: () {
                          // Placeholder
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          // Placeholder
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.privacy_tip,
                        title: 'Privacy',
                        onTap: () {
                          // Placeholder
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {
                          // Placeholder
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.info,
                        title: 'About',
                        onTap: () {
                          // Placeholder
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.cyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.textSecondary,
        size: 20,
      ),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary.withValues(alpha:0.5),
        size: 16,
      ),
      onTap: onTap,
    );
  }
}

class AchievementInfo {
  final String label;
  final String emoji;
  final Color color;
  final bool unlocked;

  const AchievementInfo({
    required this.label,
    required this.emoji,
    required this.color,
    required this.unlocked,
  });
}
