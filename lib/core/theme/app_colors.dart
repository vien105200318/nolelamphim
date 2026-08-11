import 'package:flutter/material.dart';

/// Design tokens — khớp 1:1 với `MOBILE_UI_SPEC.md` §2.1 & web `global.css`.
///
/// Lưu ý: giữ nguyên tên hằng cũ để TV (features/tv) không bị vỡ, chỉ đổi giá trị.
class AppColors {
  AppColors._();

  // ---- Nền ----
  static const Color bgDeeper = Color(0xFF06060E);
  static const Color bgDark = Color(0xFF0A0A14);
  static const Color bgSurface = Color(0xFF111122);
  static const Color bgCard = Color(0xFF181830);

  // ---- Chữ ----
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // rgba(255,255,255,0.7)
  static const Color textMuted = Color(0x66FFFFFF); // rgba(255,255,255,0.4)

  // ---- Gradient accent: hồng → tím → xanh dương ----
  static const Color gradientStart = Color(0xFFFF6B9D);
  static const Color gradientMid = Color(0xFFC44BED);
  static const Color gradientEnd = Color(0xFF4A9EFF);

  static List<Color> get accentGradient =>
      [gradientStart, gradientMid, gradientEnd];

  /// Legacy aliases — màu accent đỏ cũ được thay bằng đầu dải gradient.
  static const Color primary = gradientStart;
  static const Color primaryDark = Color(0xFFB04C87);
  static const Color accentBlue = Color(0xFF4A9EFF);

  /// Sao rating (vàng theo web `.star-filled`).
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color starEmpty = Color(0x33FFFFFF); // rgba(255,255,255,0.2)

  // ---- Glass ----
  static const Color glassWhite = Color(0x14FFFFFF); // 0.08
  static const Color glassHover = Color(0x29FFFFFF); // 0.16
  static const Color glassBorder = Color(0x1FFFFFFF); // 0.12
  static const Color glassBorderHover = Color(0x40FFFFFF); // 0.25

  /// Viền/inset highlight mạnh hơn (specular cap).
  static const Color glassHighlight = Color(0x47FFFFFF); // 0.28

  /// Nền đục bù cho panel glass khi KHÔNG dùng backdrop-filter (mobile perf).
  static const Color glassBackdrop = Color(0x8C121228); // rgba(18,18,40,0.55)

  // ---- Màu riêng cho nội dung ----
  static const Color badgeNew = Color(0xFF4A9EFF);
  static const Color badgeMarvel = Color(0xFFE62429);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color orange = Color(0xFFFFB020);
  static const Color violet = Color(0xFF7C3AED);
  static const Color amber = Color(0xFFFF9A3C);
  static const Color emerald = Color(0xFF34D399);

  static const Color glassGradient = Color(0xFF121228);
}
