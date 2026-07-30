import 'package:go_router/go_router.dart';
import '../features/home/screens/home_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/category/screens/category_screen.dart';
import '../features/category/screens/category_movies_screen.dart';
import '../features/favorites/screens/favorites_screen.dart';
import '../features/favorites/screens/history_screen.dart';
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
          routes: [
            GoRoute(
              path: ':type/:slug',
              builder: (_, state) {
                final type = state.pathParameters['type']!;
                final slug = state.pathParameters['slug']!;
                final labels = {
                  'the-loai': 'Thể loại',
                  'quoc-gia': 'Quốc gia',
                  'nam': 'Năm',
                };
                final title = '${labels[type] ?? type} - $slug';
                return CategoryMoviesScreen(
                  type: type,
                  slug: slug,
                  title: title,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/favorites',
          builder: (_, _) => const FavoritesScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (_, _) => const HistoryScreen(),
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
        movieName: state.extra as String? ?? state.pathParameters['slug']!,
      ),
    ),
  ],
);
