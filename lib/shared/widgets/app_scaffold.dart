import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'glass_panel.dart';

/// Shell mobile: giữ cấu trúc Bottom NavigationBar (không bắt chước layout web),
/// chỉ restyle theo "liquid glass" — thanh kính nổi, tab active có gradient pill.
class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

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
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.grid_view_outlined,
    Icons.favorite_outline,
    Icons.history_outlined,
  ];

  static const _labels = ['Trang chủ', 'Tìm kiếm', 'Danh mục', 'Yêu thích', 'Đã xem'];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 4, 12, bottomInset == 0 ? 10 : bottomInset),
      child: DecoratedBox(
        decoration: liquidGlassDecoration(radius: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: 46,
            height: 30,
            decoration: selected
                ? const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gradientStart,
                        AppColors.gradientMid,
                        AppColors.gradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x404A9EFF),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  )
                : null,
            child: Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
