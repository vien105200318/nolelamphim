import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class TvScaffold extends StatelessWidget {
  final Widget child;

  const TvScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TvSidebar(),
        Expanded(child: child),
      ],
    );
  }
}

class _TvSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, label: 'Trang chủ', path: '/'),
      _NavItem(icon: Icons.search, label: 'Tìm kiếm', path: '/search'),
      _NavItem(icon: Icons.category_outlined, label: 'Thể loại', path: '/category'),
      _NavItem(icon: Icons.favorite_outline, label: 'Yêu thích', path: '/favorites'),
      _NavItem(icon: Icons.history, label: 'Đã xem', path: '/history'),
    ];

    return Container(
      width: 100,
      color: AppColors.bgDark.withValues(alpha: 0.95),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
              ),
            ),
            child: const Center(
              child: Text('N', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (_, i) => _SidebarItem(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String path;

  const _NavItem({required this.icon, required this.label, required this.path});
}

class _SidebarItem extends StatelessWidget {
  final _NavItem item;

  const _SidebarItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final routed = GoRouterState.of(context);
    final active = routed.matchedLocation == item.path ||
        (item.path != '/' && routed.matchedLocation.startsWith(item.path));

    return Focus(
      child: Builder(builder: (ctx) {
        final focused = Focus.of(ctx).hasFocus;
        return GestureDetector(
          onTap: () => context.go(item.path),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 84,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.gradientMid.withValues(alpha: 0.25)
                  : focused
                      ? AppColors.glassWhite
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: focused
                  ? Border.all(color: AppColors.gradientMid.withValues(alpha: 0.5), width: 2)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  color: active ? AppColors.gradientStart : AppColors.textMuted,
                  size: 24,
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: TextStyle(
                    color: active ? AppColors.textPrimary : AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
