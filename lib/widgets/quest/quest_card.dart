import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/rank_badge.dart';
import 'proof_upload_modal.dart';
import '../../providers/quest_provider.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final Function(String)? onProofSubmitted;

  const QuestCard({
    Key? key,
    required this.quest,
    this.onProofSubmitted,
  }) : super(key: key);

  String _getTimeRemaining() {
    if (quest.isDaily) {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final remaining = tomorrow.difference(now);
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else if (quest.availableUntil != null) {
      final remaining = quest.availableUntil!.difference(DateTime.now());
      if (remaining.inDays > 0) {
        return '${remaining.inDays}d';
      } else {
        return '${remaining.inHours}h';
      }
    }
    return 'No limit';
  }

  String _getStatRewardEmoji() {
    if (quest.statRewards.isEmpty) return '';
    
    final rewards = quest.statRewards.entries;
    if (rewards.length == 1) {
      final reward = rewards.first;
      switch (reward.key.toLowerCase()) {
        case 'str':
        case 'strength':
          return ' muscles';
        case 'vit':
        case 'vitality':
          return ' heart';
        case 'int':
        case 'intel':
        case 'intelligence':
          return ' brain';
        case 'cha':
        case 'charisma':
          return ' star';
        default:
          return ' +${reward.value}';
      }
    } else {
      return ' +${rewards.fold(0, (sum, r) => sum + r.value)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = AppColors.rankColor(quest.rank);
    
    return Opacity(
      opacity: quest.isCompleted ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: rankColor,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: rankColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: RankBadge + arc label + clock icon + time
              Row(
                children: [
                  RankBadge(rank: quest.rank, color: rankColor),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      quest.arc,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getTimeRemaining(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Row 2: Bold title (strikethrough if completed)
              Text(
                quest.title,
                style: AppTextStyles.sectionHeader.copyWith(
                  decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                  decorationColor: AppColors.textSecondary,
                  decorationThickness: 2,
                ),
              ),
              const SizedBox(height: 8),
              
              // Row 3: Grey description
              Text(
                quest.description,
                style: AppTextStyles.bodySecondary.copyWith(
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              
              // Row 4: XP reward | stat reward | ProofButton
              Row(
                children: [
                  // XP reward
                  Row(
                    children: [
                      const Text(
                        ' ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${quest.xpReward}',
                        style: AppTextStyles.xpNumber.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' XP',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  // Stat reward (if any)
                  if (quest.statRewards.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Text(
                          _getStatRewardEmoji(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // ProofButton
                  ProofButton(
                    isCompleted: quest.isCompleted,
                    onPressed: quest.isCompleted ? null : () async {
                      final proofPath = await showModalBottomSheet<String?>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ProofUploadModal(
                          questTitle: quest.title,
                        ),
                      );
                      
                      if (proofPath != null && onProofSubmitted != null) {
                        onProofSubmitted!(proofPath);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
