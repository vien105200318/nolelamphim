import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;
  final Duration minDuration;

  const SplashScreen({
    super.key,
    required this.child,
    this.minDuration = const Duration(seconds: 2),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scale;
  bool _showChild = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Timer(widget.minDuration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) setState(() => _showChild = true);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showChild) return widget.child;

    return Stack(
      children: [
        widget.child,
        FadeTransition(
          opacity: _fadeIn,
          child: Container(
            color: AppColors.bgDark,
            child: Stack(
              children: [
                const _SplashBg(),
                Center(
                  child: ScaleTransition(
                    scale: _scale,
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Logo(),
                          SizedBox(height: 24),
                          _AppName(),
                          SizedBox(height: 48),
                          _SplashProgressBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SplashBg extends StatefulWidget {
  const _SplashBg();

  @override
  State<_SplashBg> createState() => _SplashBgState();
}

class _SplashBgState extends State<_SplashBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, _) {
        return CustomPaint(
          painter: _LiquidBlobPainter(
            colors: AppColors.accentGradient,
            phase: _controller.value * 2 * 3.14159,
          ),
          size: MediaQuery.of(ctx).size,
        );
      },
    );
  }
}

class _LiquidBlobPainter extends CustomPainter {
  final List<Color> colors;
  final double phase;

  _LiquidBlobPainter({required this.colors, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < colors.length; i++) {
      final t = i / colors.length;
      final px = size.width * (0.2 + 0.6 * t + 0.1 * math.sin(phase));
      final py = size.height * (0.3 + 0.4 * (1 - t) + 0.08 * math.cos(phase + t * 2));

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [colors[i].withValues(alpha: 0.07), colors[i].withValues(alpha: 0)],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(
          center: Offset(px, py),
          radius: size.width * 0.45,
        ));

      canvas.drawCircle(Offset(px, py), size.width * 0.45, paint);
    }
  }

  @override
  bool shouldRepaint(_LiquidBlobPainter old) => old.phase != phase;
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientMid.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.png',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
      ).createShader(bounds),
      child: const Text(
        'nolelamphim',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SplashProgressBar extends StatefulWidget {
  const _SplashProgressBar();

  @override
  State<_SplashProgressBar> createState() => _SplashProgressBarState();
}

class _SplashProgressBarState extends State<_SplashProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, _) {
        final value = _controller.value;
        final start = (value * 2 - 1).clamp(0.0, 1.0);
        final end = ((value + 0.3) * 2 - 1).clamp(0.0, 1.0);
        return Container(
          width: 160,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: AppColors.glassWhite,
          ),
          child: Stack(
            children: [
              Positioned(
                left: start * 160,
                right: (1 - end) * 160,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
