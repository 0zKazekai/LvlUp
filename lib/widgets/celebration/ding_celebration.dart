import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class DingCelebration extends StatefulWidget {
  final int xpGained;
  final String statLabel;
  final int statGained;
  final VoidCallback? onDismiss;

  const DingCelebration({
    Key? key,
    required this.xpGained,
    required this.statLabel,
    required this.statGained,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<DingCelebration> createState() => _DingCelebrationState();
}

class _DingCelebrationState extends State<DingCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    ));

    _controller.forward();

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (mounted) {
      widget.onDismiss?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismiss,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.cyan.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lightning bolt emoji
                    const Text(
                      ' ',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 8),
                    
                    // Terminal text
                    Text(
                      'QUEST COMPLETE',
                      style: AppTextStyles.terminal.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Large XP number in cyan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${widget.xpGained}',
                          style: AppTextStyles.xpNumber.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: AppColors.cyan,
                          ),
                        ),
                        Text(
                          ' XP',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 24,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Stat line in purple
                    if (widget.statGained > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+${widget.statGained} ',
                            style: AppTextStyles.statNumber.copyWith(
                              fontSize: 20,
                              color: AppColors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.statLabel.toUpperCase(),
                            style: AppTextStyles.body.copyWith(
                              fontSize: 20,
                              color: AppColors.purple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    // Tap to dismiss hint
                    Text(
                      'TAP TO DISMISS',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
