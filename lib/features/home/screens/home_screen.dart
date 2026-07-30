import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/liquid_background.dart';
import '../providers/home_provider.dart';
import '../widgets/movie_carousel.dart';
import '../widgets/movie_grid.dart';
import '../widgets/movie_horizontal_list.dart';

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
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: GradientText(text: 'Nô Lệ Làm Phim', fontSize: 20),
              pinned: true,
              backgroundColor: AppColors.bgDark.withValues(alpha: 0.6),
            ),
            newMoviesAsync.when(
              data: (movies) {
                if (movies.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie_outlined,
                              size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Chưa có phim nào',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () {
                              ref.invalidate(newMoviesProvider);
                              ref.invalidate(subteamProvider);
                            },
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      MovieCarousel(movies: movies),
                      const SizedBox(height: 8),
                      subteamAsync.when(
                        data: (subteam) => MovieHorizontalList(
                          title: 'Subteam',
                          movies: subteam,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: GlassPanel(
                          blur: 8,
                          borderOpacity: 0.06,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 3,
                                height: 20,
                                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.accentGradient,
                  ),
                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Phim mới cập nhật',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MovieGrid(movies: movies),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
              loading: () => const SliverFillRemaining(child: _HomeLoading()),
              error: (e, _) => SliverFillRemaining(
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
                        onPressed: () {
                          ref.invalidate(newMoviesProvider);
                          ref.invalidate(subteamProvider);
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;

  const GradientText({super.key, required this.text, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: AppColors.accentGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            color: AppColors.bgCard,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                6,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 14,
                            color: AppColors.bgCard,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 80,
                            height: 12,
                            color: AppColors.bgCard,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
