import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../common/rank_badge.dart';
import '../../entities/proof_post.dart';

class ProofPostCard extends StatelessWidget {
  final ProofPost post;
  final Function(String)? onLike;

  const ProofPostCard({
    Key? key,
    required this.post,
    this.onLike,
  }) : super(key: key);

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(post.createdAt);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getAvatarInitial() {
    if (post.userName.isEmpty) return '?';
    return post.userName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar, username, time, rank badge
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar circle with initial
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.cyan.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getAvatarInitial(),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Username and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getTimeAgo(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rank badge
                RankBadge(
                  rank: post.questRank,
                  color: AppColors.rankColor(post.questRank),
                ),
              ],
            ),
          ),
          
          // Quest name with bolt icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  ' ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  post.questTitle,
                  style: AppTextStyles.questTitle.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Caption text if present
          if (post.caption.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post.caption,
                style: AppTextStyles.questDesc.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // Image or placeholder box
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardBg2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.textSecondary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: post.imagePath.startsWith('assets/')
                  ? Image.asset(
                      post.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    )
                  : Image.network(
                      post.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Footer: XP earned | heart icon + like count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // XP earned
                Row(
                  children: [
                    const Text(
                      ' ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '+${post.xpEarned}',
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
                
                const Spacer(),
                
                // Heart icon + like count
                GestureDetector(
                  onTap: () => onLike?.call(post.id),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                        color: post.isLikedByMe ? Colors.red : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.likes.toString(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
