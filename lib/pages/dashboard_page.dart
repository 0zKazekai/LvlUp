import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/user_provider.dart';
import '../providers/quest_provider.dart';
import '../widgets/common/xp_bar.dart';
import '../widgets/common/system_message.dart';
import '../widgets/common/progress_ring.dart';
import '../widgets/quest/quest_card.dart';
import '../widgets/celebration/ding_celebration.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _statsAnimationController;
  bool _showCelebration = false;
  int _lastXpGained = 0;
  String _lastStatGained = '';
  int _lastStatAmount = 0;

  @override
  void initState() {
    super.initState();
    _statsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _statsAnimationController.forward();
  }

  @override
  void dispose() {
    _statsAnimationController.dispose();
    super.dispose();
  }

  void _handleQuestCompletion(String questId, String proofPath) {
    final questProvider = context.read<QuestProvider>();
    final userProvider = context.read<UserProvider>();
    
    final quest = questProvider.getQuestById(questId);
    if (quest != null) {
      // Calculate rewards
      _lastXpGained = quest.xpReward;
      _lastStatAmount = quest.statRewards.values.fold(0, (sum, val) => sum + val);
      _lastStatGained = quest.statRewards.keys.isNotEmpty 
          ? quest.statRewards.keys.first 
          : '';
      
      // Complete quest
      questProvider.completeQuest(questId, proofPath: proofPath);
      userProvider.completeQuest(quest);
      
      // Show celebration
      setState(() {
        _showCelebration = true;
      });
    }
  }

  void _dismissCelebration() {
    setState(() {
      _showCelebration = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Consumer<QuestProvider>(
              builder: (context, questProvider, child) {
                final userStats = userProvider.userStats;
                final todaysQuests = questProvider.todaysQuests;
                final completedCount = todaysQuests.where((q) => q.isCompleted).length;
                
                return CustomScrollView(
                  slivers: [
                    // Header with gradient text
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ShaderMask gradient 'LvlUp' text + badge
                            Row(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
                                  child: Text(
                                    'LvlUp',
                                    style: AppTextStyles.appName.copyWith(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.cyan.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.cyan.withOpacity(0.5),
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
                                        userStats.title,
                                        style: AppTextStyles.levelBadge.copyWith(
                                          color: AppColors.cyan,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // XPBar widget
                            XPBar(
                              level: userStats.level,
                              currentXP: userStats.currentXP,
                              maxXP: userStats.xpToNextLevel,
                              animate: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // SystemMessage
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SystemMessage(
                          message: 'Your training window is open. Do not waste it, Player.',
                        ),
                      ),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    
                    // Section header: TODAY'S QUESTS
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TODAY\'S QUESTS',
                              style: AppTextStyles.sectionHeader.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.textSecondary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '$completedCount/${todaysQuests.length} Complete',
                                style: AppTextStyles.label.copyWith(
                                  color: completedCount == todaysQuests.length 
                                      ? AppColors.rankC 
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    
                    // List of QuestCard widgets
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final quest = todaysQuests[index];
                          return QuestCard(
                            quest: quest,
                            onProofSubmitted: (proofPath) {
                              _handleQuestCompletion(quest.id, proofPath);
                            },
                          );
                        },
                        childCount: todaysQuests.length,
                      ),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    
                    // Section header: CHARACTER STATS
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
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    
                    // Row of 4 ProgressRing widgets
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // STR - red
                            ProgressRing(
                              label: 'STR',
                              value: userStats.str.toDouble(),
                              max: userStats.maxStat.toDouble(),
                              color: AppColors.statStr,
                              controller: _statsAnimationController,
                              size: 80,
                            ),
                            // VIT - green
                            ProgressRing(
                              label: 'VIT',
                              value: userStats.vit.toDouble(),
                              max: userStats.maxStat.toDouble(),
                              color: AppColors.statVit,
                              controller: _statsAnimationController,
                              size: 80,
                            ),
                            // INT - cyan
                            ProgressRing(
                              label: 'INT',
                              value: userStats.intel.toDouble(),
                              max: userStats.maxStat.toDouble(),
                              color: AppColors.statInt,
                              controller: _statsAnimationController,
                              size: 80,
                            ),
                            // CHA - purple
                            ProgressRing(
                              label: 'CHA',
                              value: userStats.cha.toDouble(),
                              max: userStats.maxStat.toDouble(),
                              color: AppColors.statCha,
                              controller: _statsAnimationController,
                              size: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                );
              },
            );
          },
        ),
        
        // DingCelebration overlay
        if (_showCelebration)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: DingCelebration(
                  xpGained: _lastXpGained,
                  statLabel: _lastStatGained,
                  statGained: _lastStatAmount,
                  onDismiss: _dismissCelebration,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
