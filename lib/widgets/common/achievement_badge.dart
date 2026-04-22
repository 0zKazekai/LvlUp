import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AchievementBadge extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final bool unlocked;

  const AchievementBadge({
    Key? key,
    required this.label,
    required this.emoji,
    required this.color,
    required this.unlocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.35,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: unlocked ? color : AppColors.textSecondary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: unlocked ? color : AppColors.textSecondary,
                fontWeight: unlocked ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
