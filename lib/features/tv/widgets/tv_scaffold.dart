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
      _NavItem(icon: Icons.home_filled, label: 'Trang chủ', path: '/'),
      _NavItem(icon: Icons.search, label: 'Tìm kiếm', path: '/search'),
      _NavItem(icon: Icons.category, label: 'Thể loại', path: '/category'),
      _NavItem(icon: Icons.favorite, label: 'Yêu thích', path: '/favorites'),
      _NavItem(icon: Icons.history, label: 'Đã xem', path: '/history'),
    ];

    return Container(
      width: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.bgDark.withValues(alpha: 0.98),
            AppColors.bgSurface.withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          right: BorderSide(color: AppColors.glassBorder, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Row(
            children: [
              const SizedBox(width: 20),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
                  ),
                ),
                child: const Center(
                  child: Text('N', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nô Lệ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Làm Phim',
                    style: TextStyle(
                      color: AppColors.gradientMid,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (_, i) => _SidebarItem(item: items[i]),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.1),
                  AppColors.gradientMid.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gradientMid,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'TV Mode',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.gradientMid.withValues(alpha: 0.2)
                  : focused
                      ? AppColors.glassWhite
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: focused
                  ? Border.all(color: AppColors.gradientMid.withValues(alpha: 0.5), width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                if (active)
                  Container(
                    width: 3,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.gradientStart, AppColors.gradientMid],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(width: 3),
                const SizedBox(width: 12),
                Icon(
                  item.icon,
                  color: active ? AppColors.gradientStart : (focused ? AppColors.textPrimary : AppColors.textMuted),
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: TextStyle(
                    color: active ? AppColors.textPrimary : (focused ? AppColors.textPrimary : AppColors.textSecondary),
                    fontSize: 15,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                if (active)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.gradientStart, AppColors.gradientMid],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
