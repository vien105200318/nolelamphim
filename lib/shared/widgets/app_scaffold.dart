import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/tv_detector.dart';

class AppScaffold extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: NavigationBar(
            selectedIndex: _currentIndex(context),
            onDestinationSelected: (index) {
              switch (index) {
                case 0: context.go('/'); break;
                case 1: context.go('/search'); break;
                case 2: context.go('/category'); break;
                case 3: context.go('/favorites'); break;
                case 4: context.go('/history'); break;
              }
            },
            backgroundColor: AppColors.bgDark.withValues(alpha: 0.6),
            indicatorColor: AppColors.glassWhite,
            destinations: [
              NavigationDestination(
                icon: _NavIcon(icon: Icons.home_outlined, index: 0),
                selectedIcon: const Icon(Icons.home, color: AppColors.gradientStart),
                label: 'Trang chủ',
              ),
              const NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search, color: AppColors.gradientMid),
                label: 'Tìm kiếm',
              ),
              const NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category, color: AppColors.gradientEnd),
                label: 'Danh mục',
              ),
              const NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon: Icon(Icons.favorite, color: AppColors.gradientStart),
                label: 'Yêu thích',
              ),
              const NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history, color: AppColors.gradientMid),
                label: 'Đã xem',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends ConsumerWidget {
  final IconData icon;
  final int index;

  const _NavIcon({required this.icon, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTvActive = ref.watch(tvModeProvider);

    return GestureDetector(
      onLongPress: () {
        ref.read(tvModeProvider.notifier).state = !isTvActive;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isTvActive ? 'Đã tắt TV mode' : 'Đã bật TV mode (xoay ngang để xem)'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Icon(icon),
    );
  }
}
