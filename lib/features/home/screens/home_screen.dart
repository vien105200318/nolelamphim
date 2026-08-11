import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/liquid_background.dart';
import '../providers/home_provider.dart';
import '../widgets/continue_watching.dart';
import '../widgets/movie_carousel.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_grid.dart';
import '../widgets/movie_horizontal_list.dart';
import '../widgets/theme_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newMoviesAsync = ref.watch(newMoviesProvider);
    final subteamAsync = ref.watch(subteamProvider);

    return LiquidBackground(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(newMoviesProvider);
          ref.invalidate(subteamProvider);
          await ref.read(newMoviesGridProvider.notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: GradientText(text: 'Nô Lệ Làm Phim', fontSize: 20),
              pinned: true,
              backgroundColor: AppColors.bgDark.withValues(alpha: 0.6),
            ),
            SliverToBoxAdapter(
              child: newMoviesAsync.when(
                data: (movies) => HeroCarousel(movies: movies),
                loading: () => const _HeroSkeleton(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
            const SliverToBoxAdapter(child: ThemeSection()),
            const SliverToBoxAdapter(child: ContinueWatching()),
            SliverToBoxAdapter(
              child: subteamAsync.when(
                data: (subteam) => MovieHorizontalList(
                  title: 'Subteam',
                  movies: subteam,
                  dot: MovieDot.hot,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final category in homeCategories)
                    _CategoryRow(category: category),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: _SectionHeader(title: 'Phim mới cập nhật'),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: _buildNewMoviesGrid(ref),
            ),
            SliverPadding(
              padding:
                  EdgeInsets.only(bottom: AppScaffold.navBarBottomPadding(context)),
              sliver: const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewMoviesGrid(WidgetRef ref) {
    final state = ref.watch(newMoviesGridProvider);
    final notifier = ref.read(newMoviesGridProvider.notifier);

    if (state.movies.isEmpty && state.error != null && !state.isLoading) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              const Text(
                'Không thể tải dữ liệu',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => notifier.refresh(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.movies.isEmpty && state.isLoading) {
      return const SliverToBoxAdapter(child: _GridSkeleton());
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          MovieGrid(movies: state.movies, dot: MovieDot.newMovie),
          LoadMoreButton(
            loading: state.isLoading,
            hasMore: state.hasMore,
            onTap: () => notifier.loadMore(),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  final HomeCategory category;

  const _CategoryRow({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(homeCategoryMoviesProvider(category.slug));

    return moviesAsync.when(
      data: (movies) {
        if (movies.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: _SectionHeader(title: category.name),
                  ),
                  GestureDetector(
                    onTap: () => context.push(
                      '/category/the-loai/${category.slug}',
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem tất cả',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 265,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: movies.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) => SizedBox(
                  width: 150,
                  child: MovieCard(movie: movies[index]),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      blur: 8,
      borderOpacity: 0.06,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.accentGradient),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.32;
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(width: 90, height: 12, color: Colors.white),
            const SizedBox(height: 4),
            Container(width: 60, height: 10, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
