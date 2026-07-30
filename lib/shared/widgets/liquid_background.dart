import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? gradient;

  const LiquidBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _LiquidPainter(gradient ?? AppColors.accentGradient),
          ),
        ),
        child,
      ],
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final List<Color> colors;

  _LiquidPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < colors.length; i++) {
      paint.shader = RadialGradient(
        colors: [colors[i].withValues(alpha: 0.12), colors[i].withValues(alpha: 0)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(
          size.width * (0.2 + 0.6 * (i / colors.length)),
          size.height * (0.15 + 0.5 * (i / colors.length)),
        ),
        radius: size.width * 0.6,
      ));

      canvas.drawCircle(
        Offset(
          size.width * (0.2 + 0.6 * (i / colors.length)),
          size.height * (0.3 + 0.4 * (i / colors.length)),
        ),
        size.width * 0.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_LiquidPainter oldDelegate) => false;
}

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;

  const GradientText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: AppColors.accentGradient,
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
