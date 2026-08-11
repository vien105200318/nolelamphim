import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Lớp nền "liquid" — 1 layer tĩnh duy nhất (gradient dọc + các blob màu mờ),
/// vẽ bằng CustomPaint, KHÔNG repaint khi scroll, KHÔNG backdrop-filter.
/// Đúng spec §2.2: nền tối `#0b0a1c → #0a0a14 → #0c0a1a` + 5 đốm màu góc.
class LiquidBackground extends StatelessWidget {
  final Widget child;

  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const IgnorePointer(child: CustomPaint(painter: _LiquidPainter())),
        child,
      ],
    );
  }
}

class _LiquidPainter extends CustomPainter {
  const _LiquidPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0B0A1C), Color(0xFF0A0A14), Color(0xFF0C0A1A)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, basePaint);

    _blob(canvas, size, const Offset(0.12, 0.12), const Color(0xFFFF5C9E), 0.32);
    _blob(canvas, size, const Offset(0.88, 0.10), const Color(0xFF528CFF), 0.34);
    _blob(canvas, size, const Offset(0.82, 0.82), const Color(0xFF9650FF), 0.30);
    _blob(canvas, size, const Offset(0.18, 0.88), const Color(0xFF00D6C8), 0.20);
    _blob(canvas, size, const Offset(0.52, 0.46), const Color(0xFFFFB03C), 0.12);
  }

  void _blob(
    Canvas canvas,
    Size size,
    Offset anchor,
    Color color,
    double opacity,
  ) {
    final center = Offset(size.width * anchor.dx, size.height * anchor.dy);
    final radius = size.shortestSide * 0.7;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.35),
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Chữ gradient accent (dùng cho logo, 404...).
class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final List<Color>? colors;

  const GradientText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
    this.textAlign,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors ?? AppColors.accentGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
