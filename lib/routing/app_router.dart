import 'package:go_router/go_router.dart';
import '../features/home/screens/home_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/category/screens/category_screen.dart';
import '../features/movie_detail/screens/movie_detail_screen.dart';
import '../features/watch/screens/watch_screen.dart';
import '../shared/widgets/app_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (_, _) => const SearchScreen(),
        ),
        GoRoute(
          path: '/category',
          builder: (_, _) => const CategoryScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/phim/:slug',
      builder: (_, state) => MovieDetailScreen(
        slug: state.pathParameters['slug']!,
      ),
    ),
    GoRoute(
      path: '/xem/:slug/:episode',
      builder: (_, state) => WatchScreen(
        slug: state.pathParameters['slug']!,
        episode: state.pathParameters['episode']!,
      ),
    ),
  ],
);
