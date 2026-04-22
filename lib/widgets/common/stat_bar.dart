import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatBar extends StatefulWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  const StatBar({
    Key? key,
    required this.label,
    required this.value,
    required this.max,
    required this.color,
  }) : super(key: key);

  @override
  State<StatBar> createState() => _StatBarState();
}

class _StatBarState extends State<StatBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: widget.value / widget.max,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(StatBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.max != widget.max) {
      final newProgress = widget.value / widget.max;
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
              widget.label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Text(
              '${widget.value}/${widget.max}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: _fillAnimation,
          builder: (context, child) {
            return Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.cardBg2,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _fillAnimation.value.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.4),
                        blurRadius: 6,
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
