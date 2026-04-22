import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProgressRing extends StatefulWidget {
  final String label;
  final double value;
  final double max;
  final Color color;
  final AnimationController? controller;
  final double size;

  const ProgressRing({
    Key? key,
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    this.controller,
    this.size = 60.0,
  }) : super(key: key);

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController(
          duration: const Duration(milliseconds: 1000),
          vsync: this,
        );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value / widget.max,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.max != widget.max) {
      final newProgress = widget.value / widget.max;
      _animation = Tween<double>(
        begin: _animation.value,
        end: newProgress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: _animation.value);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _RingPainter(
              progress: _animation.value.clamp(0.0, 1.0),
              color: widget.color,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.value.toInt()}',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: widget.size * 0.25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: widget.size * 0.15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final strokeWidth = 6.0;

    // Draw track
    final trackPaint = Paint()
      ..color = AppColors.cardBg2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

      final sweepAngle = 2 * 3.14159 * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );

      // Draw glow effect
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
