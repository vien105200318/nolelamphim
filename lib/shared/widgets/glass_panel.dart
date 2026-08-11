import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Hệ "Liquid Glass" — 5 biến thể theo `MOBILE_UI_SPEC.md` §3.
///
/// Mobile (perf): KHÔNG dùng backdrop-filter; bù bằng nền đục hơn
/// (`rgba(18,18,40,0.55)` + gradient trắng nhẹ phía trên) để giữ look.
class GlassStyle {
  GlassStyle._();

  static const _white = Color(0xFFFFFFFF);

  /// `rgba(18,18,40,0.55)` — nền đục bù cho blur (mobile).
  static const Color backdrop = Color(0x8C121228);

  static LinearGradient whiteGradient(List<double> stops) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _white.withValues(alpha: stops[0]),
          _white.withValues(alpha: stops[1]),
          _white.withValues(alpha: stops[2]),
        ],
      );
}

BoxDecoration glassTileDecoration({
  double radius = 12,
  bool active = false,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: active
        ? GlassStyle.whiteGradient(const [0.2, 0.06, 0.12])
        : GlassStyle.whiteGradient(const [0.09, 0.025, 0.05]),
    color: active
        ? AppColors.glassBackdrop.withValues(alpha: 0.9)
        : AppColors.glassBackdrop,
    border: Border.all(
      color: _white(active ? 0.26 : 0.13),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: active ? 0.3 : 0.25),
        blurRadius: active ? 16 : 12,
        offset: Offset(0, active ? 2 : 2),
      ),
      if (active)
        BoxShadow(
          color: AppColors.gradientMid.withValues(alpha: 0.15),
          blurRadius: 0,
          spreadRadius: 1,
        ),
      BoxShadow(
        color: _white(active ? 0.28 : 0.18),
        offset: const Offset(0, 1),
        blurRadius: 0,
      ),
    ],
  );
}

Color _white(double alpha) => Colors.white.withValues(alpha: alpha);

BoxDecoration liquidGlassDecoration({
  double radius = 24,
  bool flat = false,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: GlassStyle.whiteGradient(const [0.18, 0.04, 0.09]),
    color: AppColors.glassBackdrop,
    border: Border.all(color: _white(0.22)),
    boxShadow: flat
        ? const []
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 40,
              offset: const Offset(0, 12),
              spreadRadius: -12,
            ),
            BoxShadow(color: _white(0.34), offset: const Offset(0, 1)),
            BoxShadow(
              color: _white(0.05),
              offset: const Offset(0, -1),
              blurRadius: 0,
            ),
            const BoxShadow(
                color: Color(0x14FFFFFF), offset: Offset(-1, 0), blurRadius: 0),
            const BoxShadow(
                color: Color(0x14FFFFFF), offset: Offset(1, 0), blurRadius: 0),
          ],
  );
}

BoxDecoration contentCardDecoration({double radius = 14}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: GlassStyle.whiteGradient(const [0.09, 0.03, 0.065]),
    color: AppColors.glassBackdrop,
    border: Border.all(color: _white(0.12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 30,
        offset: const Offset(0, 8),
        spreadRadius: -12,
      ),
      BoxShadow(color: _white(0.16), offset: const Offset(0, 1)),
    ],
  );
}

BoxDecoration glassChipDecoration({double radius = 8}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x1AFFFFFF), Color(0x08FFFFFF)],
    ),
    border: Border.all(color: _white(0.11)),
    boxShadow: [
      BoxShadow(color: _white(0.14), offset: const Offset(0, 1)),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ],
  );
}

BoxDecoration glassFrameDecoration({double radius = 12}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: _white(0.13)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.45),
        blurRadius: 20,
        offset: const Offset(0, 4),
        spreadRadius: -6,
      ),
      BoxShadow(color: _white(0.2), offset: const Offset(0, 1)),
      BoxShadow(color: _white(0.04), offset: const Offset(0, -1)),
    ],
  );
}

/// Trang phân trang đang active — gradient hồng→tím→xanh (spec §3.6).
BoxDecoration paginationActiveDecoration({double radius = 12}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.gradientStart,
        AppColors.gradientMid,
        AppColors.gradientEnd,
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.gradientMid.withValues(alpha: 0.25),
        blurRadius: 15,
        offset: const Offset(0, 10),
        spreadRadius: -3,
      ),
    ],
  );
}

/// Đoạn `BoxDecoration` chung cho các box.
BoxDecoration glassBox({
  required BoxDecoration decoration,
}) {
  return decoration;
}

// ============================================================
// Widgets
// ============================================================

/// Panel kính lớn (section, hero frame, toast...). Radius mặc định 24.
class LiquidGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double radius;

  const LiquidGlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: liquidGlassDecoration(radius: radius),
      child: child,
    );
  }
}

/// Card nội dung (Nội dung phim, danh sách tập, empty state). Radius 14.
class ContentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ContentCard({super.key, required this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: contentCardDecoration(),
      child: child,
    );
  }
}

/// Tile nhỏ (nút, chip click, select, pagination).
class GlassTile extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool active;
  final double radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassTile({
    super.key,
    required this.child,
    this.onTap,
    this.active = false,
    this.radius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = glassTileDecoration(radius: radius, active: active);
    final content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration,
      alignment: Alignment.center,
      child: child,
    );
    if (onTap == null) return content;
    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}

/// Chip tĩnh nhỏ (meta, keyword) — không cần blur.
class GlassChip extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassChip({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: glassChipDecoration(radius: radius),
      child: child,
    );
  }
}

/// Khung kính ép cho ảnh (poster, hero, banner).
class GlassFrame extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final double radius;

  const GlassFrame({
    super.key,
    required this.child,
    this.borderRadius,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: glassFrameDecoration(radius: radius),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}

// ============================================================
// Legacy: `GlassPanel` cũ — giữ signature để không vỡ code đang dùng.
// ============================================================

class GlassPanel extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final List<Color>? gradient;
  final double blur;
  final double borderOpacity;

  const GlassPanel({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradient,
    this.blur = 12,
    this.borderOpacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        gradient: gradient != null
            ? LinearGradient(
                colors: gradient!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : GlassStyle.whiteGradient(const [0.09, 0.025, 0.05]),
        color: AppColors.glassBackdrop,
        border: Border.all(
          color: Colors.white.withValues(alpha: borderOpacity),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: blur,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
