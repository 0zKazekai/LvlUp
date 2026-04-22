import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/quest_provider.dart';
import '../../widgets/arc/arc_challenge_tracker.dart';
import '../../widgets/quest/quest_card.dart';
import '../../widgets/chat/system_os_chat.dart';

class MyArcPage extends StatefulWidget {
  const MyArcPage({Key? key}) : super(key: key);

  @override
  State<MyArcPage> createState() => _MyArcPageState();
}

class _MyArcPageState extends State<MyArcPage> {
  String _selectedArc = 'Fitness';

  final List<ArcInfo> _arcs = [
    ArcInfo(
      name: 'Fitness',
      emoji: ' ',
      color: AppColors.statStr,
    ),
    ArcInfo(
      name: 'Scholar',
      emoji: ' ',
      color: AppColors.statInt,
    ),
    ArcInfo(
      name: 'Entrepreneur',
      emoji: ' ',
      color: AppColors.purple,
    ),
    ArcInfo(
      name: 'Mindset',
      emoji: ' ',
      color: AppColors.cyan,
    ),
    ArcInfo(
      name: 'Creative',
      emoji: ' ',
      color: AppColors.rankB,
    ),
    ArcInfo(
      name: 'Social',
      emoji: ' ',
      color: AppColors.statCha,
    ),
  ];

  // Sample progress data for demo
  final Map<String, ArcProgress> _arcProgress = {
    'Fitness': ArcProgress(completedDays: 18, totalDays: 30),
    'Scholar': ArcProgress(completedDays: 12, totalDays: 30),
    'Entrepreneur': ArcProgress(completedDays: 8, totalDays: 30),
    'Mindset': ArcProgress(completedDays: 22, totalDays: 30),
    'Creative': ArcProgress(completedDays: 5, totalDays: 30),
    'Social': ArcProgress(completedDays: 15, totalDays: 30),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'MY ARC',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Arc selection chips
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _arcs.length,
                itemBuilder: (context, index) {
                  final arc = _arcs[index];
                  final isSelected = _selectedArc == arc.name;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedArc = arc.name;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? arc.color.withOpacity(0.2) 
                            : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected 
                              ? arc.color 
                              : AppColors.textSecondary.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: arc.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            arc.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            arc.name,
                            style: AppTextStyles.label.copyWith(
                              color: isSelected ? arc.color : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ArcChallengeTracker for selected arc
          SliverToBoxAdapter(
            child: Consumer<QuestProvider>(
              builder: (context, questProvider, child) {
                final progress = _arcProgress[_selectedArc]!;
                final arc = _arcs.firstWhere((a) => a.name == _selectedArc);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ArcChallengeTracker(
                    arcName: '${_selectedArc} Challenge',
                    arcColor: arc.color,
                    completedDays: progress.completedDays,
                    totalDays: progress.totalDays,
                    emoji: arc.emoji,
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Section header for arc quests
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$_selectedArc Quests',
                style: AppTextStyles.sectionHeader.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // List of active arc quests
          Consumer<QuestProvider>(
            builder: (context, questProvider, child) {
              final arcQuests = questProvider.getQuestsByArc(_selectedArc);
              
              if (arcQuests.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.textSecondary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            size: 48,
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No $_selectedArc quests available',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for new challenges',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final quest = arcQuests[index];
                    return QuestCard(
                      quest: quest,
                      onProofSubmitted: (proofPath) {
                        // Handle quest completion
                        questProvider.completeQuest(quest.id, proofPath: proofPath);
                      },
                    );
                  },
                  childCount: arcQuests.length,
                ),
              );
            },
          ),

          // SystemOSChat - Full height AI Coach
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cyan.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'SYSTEM ADVISOR',
                          style: AppTextStyles.terminal.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyan,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.cyan.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'AI COACH',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Chat widget - takes full remaining space
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: const SystemOSChat(expanded: true),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class ArcInfo {
  final String name;
  final String emoji;
  final Color color;

  ArcInfo({
    required this.name,
    required this.emoji,
    required this.color,
  });
}

class ArcProgress {
  final int completedDays;
  final int totalDays;

  ArcProgress({
    required this.completedDays,
    required this.totalDays,
  });
}
