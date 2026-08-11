import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'glass_panel.dart';

/// Shell mobile: giữ cấu trúc Bottom NavigationBar (không bắt chước layout web),
/// chỉ restyle theo "liquid glass" — thanh kính nổi, tab active có gradient pill.
class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  /// Chiều cao phần nội dung kính: pill 48 + padding dọc 10+10.
  static const double _glassContentHeight = 68;

  /// Padding dưới cho body để nội dung cuối không bị thanh điều hướng che.
  static double navBarBottomPadding(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return _glassContentHeight + 4 + (bottom == 0 ? 10 : bottom) + 12;
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/category')) return 2;
    if (location.startsWith('/favorites')) return 3;
    if (location.startsWith('/history')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      extendBody: true,
      body: child,
      bottomNavigationBar: _GlassBottomNav(
        selectedIndex: index,
        onSelect: (i) {
          switch (i) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/category');
              break;
            case 3:
              context.go('/favorites');
              break;
            case 4:
              context.go('/history');
              break;
          }
        },
      ),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _GlassBottomNav({
    required this.selectedIndex,
    required this.onSelect,
  });

  static const _icons = <IconData>[
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.grid_view_rounded,
    Icons.favorite_rounded,
    Icons.history_rounded,
  ];

  static const _labels = ['Trang chủ', 'Tìm kiếm', 'Danh mục', 'Yêu thích', 'Đã xem'];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    // BackdropFilter trong bottomNavigationBar gây "RenderBox was not laid out"
    // trên Android emulator (Scaffold vẽ body & nav ở 2 pass riêng). iOS ổn
    // nên chỉ bật blur trên iOS/macOS, Android dùng kính ảo (đục hơn).
    final useBlur =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    final glass = DecoratedBox(
      decoration: liquidGlassDecoration(
        radius: 24,
        flat: true,
        backdrop: AppColors.glassBackdrop.withValues(
          alpha: useBlur ? 0.40 : 0.48,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: List.generate(_icons.length, (i) {
            final selected = i == selectedIndex;
            return Expanded(
              child: _NavItem(
                icon: _icons[i],
                label: _labels[i],
                selected: selected,
                onTap: () => onSelect(i),
              ),
            );
          }),
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 4, 12, bottomInset == 0 ? 10 : bottomInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: liquidGlassDecoration(radius: 24).boxShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: useBlur ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: glass) : glass,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: 76,
            height: 48,
            alignment: Alignment.center,
            decoration: selected
                ? BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientStart,
                        AppColors.gradientMid,
                        AppColors.gradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientMid.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  )
                : null,
            child: Icon(
              icon,
              size: 32,
              color: selected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
