import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class XPBar extends StatefulWidget {
  final int level;
  final int currentXP;
  final int maxXP;
  final bool animate;

  const XPBar({
    Key? key,
    required this.level,
    required this.currentXP,
    required this.maxXP,
    this.animate = true,
  }) : super(key: key);

  @override
  State<XPBar> createState() => _XPBarState();
}

class _XPBarState extends State<XPBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentXP / widget.maxXP,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(XPBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentXP != widget.currentXP || oldWidget.maxXP != widget.maxXP) {
      final newProgress = widget.currentXP / widget.maxXP;
      _fillAnimation = Tween<double>(
        begin: _fillAnimation.value,
        end: newProgress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: _fillAnimation.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LV.${widget.level}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              '${widget.currentXP}/${widget.maxXP} XP',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _fillAnimation,
          builder: (context, child) {
            return Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.cardBg2,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _fillAnimation.value.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.xpGradient,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
