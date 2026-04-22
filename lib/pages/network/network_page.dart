import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../common/rank_badge.dart';

class NetworkPage extends StatelessWidget {
  const NetworkPage({Key? key}) : super(key: key);

  final List<NetworkInfo> _sampleNetworks = const [
    NetworkInfo(
      name: 'Elite Athletes',
      memberCount: 1247,
      level: 45,
      arcType: 'Fitness',
      arcColor: AppColors.statStr,
      description: 'For those who push their physical limits',
    ),
    NetworkInfo(
      name: 'Scholar\'s Circle',
      memberCount: 892,
      level: 38,
      arcType: 'Scholar',
      arcColor: AppColors.statInt,
      description: 'Knowledge seekers and lifelong learners',
    ),
    NetworkInfo(
      name: 'Startup Founders',
      memberCount: 567,
      level: 42,
      arcType: 'Entrepreneur',
      arcColor: AppColors.purple,
      description: 'Building the future through innovation',
    ),
    NetworkInfo(
      name: 'Mind Masters',
      memberCount: 734,
      level: 35,
      arcType: 'Mindset',
      arcColor: AppColors.cyan,
      description: 'Mental wellness and personal growth',
    ),
    NetworkInfo(
      name: 'Creative Collective',
      memberCount: 423,
      level: 28,
      arcType: 'Creative',
      arcColor: AppColors.rankB,
      description: 'Artists, designers, and creators',
    ),
    NetworkInfo(
      name: 'Social Butterflies',
      memberCount: 612,
      level: 31,
      arcType: 'Social',
      arcColor: AppColors.statCha,
      description: 'Building connections and relationships',
    ),
  ];

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
                'NETWORK',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Coming Soon banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lock,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Coming Soon',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Networks will unlock at Level 15. Keep training to unlock this feature and connect with other players!',
                    style: AppTextStyles.bodySecondary.copyWith(
                      fontSize: 14,
                      color: AppColors.textSecondary.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'AVAILABLE NETWORKS',
                style: AppTextStyles.sectionHeader.copyWith(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Sample network list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final network = _sampleNetworks[index];
                return NetworkCard(network: network);
              },
              childCount: _sampleNetworks.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class NetworkCard extends StatelessWidget {
  final NetworkInfo network;

  const NetworkCard({
    Key? key,
    required this.network,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: network.arcColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: network.arcColor.withOpacity(0.2),
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
            // Name and arc type
            Row(
              children: [
                Expanded(
                  child: Text(
                    network.name,
                    style: AppTextStyles.sectionHeader.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: network.arcColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    network.arcType,
                    style: AppTextStyles.label.copyWith(
                      color: network.arcColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Description
            Text(
              network.description,
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            
            // Member count, level, and join button
            Row(
              children: [
                // Member count
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${network.memberCount}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      ' members',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Level badge
                RankBadge(
                  rank: 'LV${network.level}',
                  color: AppColors.rankC,
                ),
                
                const Spacer(),
                
                // Join button (disabled)
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                    foregroundColor: AppColors.textSecondary.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Join',
                    style: AppTextStyles.label.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkInfo {
  final String name;
  final int memberCount;
  final int level;
  final String arcType;
  final Color arcColor;
  final String description;

  const NetworkInfo({
    required this.name,
    required this.memberCount,
    required this.level,
    required this.arcType,
    required this.arcColor,
    required this.description,
  });
}
