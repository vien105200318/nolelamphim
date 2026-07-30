import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
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
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
          NavigationDestination(icon: Icon(Icons.search_outlined), label: 'Tìm kiếm'),
          NavigationDestination(icon: Icon(Icons.category_outlined), label: 'Danh mục'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), label: 'Yêu thích'),
          NavigationDestination(icon: Icon(Icons.history_outlined), label: 'Đã xem'),
        ],
      ),
    );
  }
}
