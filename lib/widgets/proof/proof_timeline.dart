import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProofTimeline extends StatelessWidget {
  final List<ProofItem> proofs;

  const ProofTimeline({
    Key? key,
    required this.proofs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (proofs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
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
              Icons.photo_camera_outlined,
              size: 48,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No proofs yet',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete quests and upload proofs to see your progress timeline',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.2),
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
                Icon(
                  Icons.timeline,
                  color: AppColors.cyan,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'PROOF TIMELINE',
                  style: AppTextStyles.sectionHeader.copyWith(
                    fontSize: 16,
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
                    '${proofs.length} proofs',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Timeline items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: proofs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final proof = proofs[index];
              return _ProofTimelineItem(proof: proof);
            },
          ),
        ],
      ),
    );
  }
}

class _ProofTimelineItem extends StatelessWidget {
  final ProofItem proof;

  const _ProofTimelineItem({
    required this.proof,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: proof.isVideo ? AppColors.orange : AppColors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.bg,
                  width: 2,
                ),
              ),
            ),
            if (proof.isLast) const SizedBox(height: 4),
            if (!proof.isLast)
              Container(
                width: 2,
                height: 80,
                color: AppColors.textSecondary.withOpacity(0.2),
              ),
          ],
        ),
        const SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and time
              Text(
                DateFormat('MMM dd, yyyy - h:mm a').format(proof.timestamp),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              
              // Quest name
              Text(
                proof.questName,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              
              // Proof type indicator
              Row(
                children: [
                  Icon(
                    proof.isVideo ? Icons.videocam : Icons.photo,
                    size: 16,
                    color: proof.isVideo ? AppColors.orange : AppColors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    proof.isVideo ? 'Video Proof' : 'Photo Proof',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: proof.isVideo ? AppColors.orange : AppColors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (proof.xpEarned > 0) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.cyan.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '+${proof.xpEarned} XP',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              // Proof preview
              if (proof.thumbnailUrl != null) ...[
                const SizedBox(height: 12),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.textSecondary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.network(
                          proof.thumbnailUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.surface,
                              child: Center(
                                child: Icon(
                                  proof.isVideo ? Icons.videocam_outlined : Icons.photo_outlined,
                                  color: AppColors.textSecondary,
                                  size: 32,
                                ),
                              ),
                            );
                          },
                        ),
                        if (proof.isVideo)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ProofItem {
  final String id;
  final String questName;
  final String? thumbnailUrl;
  final String? fullUrl;
  final DateTime timestamp;
  final bool isVideo;
  final int xpEarned;
  final bool isLast;

  ProofItem({
    required this.id,
    required this.questName,
    this.thumbnailUrl,
    this.fullUrl,
    required this.timestamp,
    required this.isVideo,
    this.xpEarned = 0,
    this.isLast = false,
  });

  factory ProofItem.fromJson(Map<String, dynamic> json) {
    return ProofItem(
      id: json['id'] ?? '',
      questName: json['quest_name'] ?? 'Unknown Quest',
      thumbnailUrl: json['thumbnail_url'],
      fullUrl: json['full_url'],
      timestamp: DateTime.parse(json['created_at']),
      isVideo: json['is_video'] ?? false,
      xpEarned: json['xp_earned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quest_name': questName,
      'thumbnail_url': thumbnailUrl,
      'full_url': fullUrl,
      'created_at': timestamp.toIso8601String(),
      'is_video': isVideo,
      'xp_earned': xpEarned,
    };
  }
}
