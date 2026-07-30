import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFFE50914);
  static const primaryDark = Color(0xFFB20710);

  static const bgDark = Color(0xFF0A0A1A);
  static const bgSurface = Color(0xFF12122A);
  static const bgCard = Color(0xFF1A1A3A);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB3B3CC);
  static const textMuted = Color(0xFF7A7A99);

  static const accentGold = Color(0xFFFFD700);
  static const accentBlue = Color(0xFF0080FF);

  static const gradientStart = Color(0xFFFF6B9D);
  static const gradientMid = Color(0xFFC44BED);
  static const gradientEnd = Color(0xFF4A9EFF);

  static List<Color> get accentGradient => [gradientStart, gradientMid, gradientEnd];

  static const glassWhite = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x2AFFFFFF);
  static const glassHighlight = Color(0x0DFFFFFF);
}
