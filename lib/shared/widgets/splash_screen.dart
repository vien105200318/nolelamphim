import 'dart:async';
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
  bool _showChild = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
      alignment: Alignment.topLeft,
      children: [
        widget.child,
        FadeTransition(
          opacity: _controller,
          child: Container(
            color: AppColors.bgDark,
            child: Center(
              child: ShaderMask(
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
