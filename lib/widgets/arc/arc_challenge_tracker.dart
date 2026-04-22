import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ArcChallengeTracker extends StatelessWidget {
  final String arcName;
  final Color arcColor;
  final int completedDays;
  final int totalDays;
  final String emoji;

  const ArcChallengeTracker({
    Key? key,
    required this.arcName,
    required this.arcColor,
    required this.completedDays,
    required this.totalDays,
    required this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = completedDays / totalDays;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: arcColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: arcColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: emoji + name + X/Y Days pill
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  arcName,
                  style: AppTextStyles.sectionHeader.copyWith(
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: arcColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: arcColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$completedDays/$totalDays Days',
                  style: AppTextStyles.label.copyWith(
                    color: arcColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Row of colored dot segments
          Row(
            children: List.generate(
              totalDays,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: 8,
                  decoration: BoxDecoration(
                    color: index < completedDays 
                        ? arcColor 
                        : AppColors.cardBg2,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: index < completedDays
                        ? [
                            BoxShadow(
                              color: arcColor.withOpacity(0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Thin progress bar below dots
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.cardBg2,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: arcColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: arcColor.withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
