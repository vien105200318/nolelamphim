import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/home_provider.dart';
import '../widgets/tv_row.dart';
import '../widgets/tv_loading.dart';
import '../widgets/tv_hero_section.dart';

class TvHomeScreen extends ConsumerWidget {
  const TvHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newMoviesAsync = ref.watch(newMoviesProvider);
    final subteamAsync = ref.watch(subteamProvider);

    return Container(
      color: AppColors.bgDark,
      child: RawScrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              newMoviesAsync.when(
                data: (movies) {
                  if (movies.isEmpty) {
                    return _buildEmpty(ref);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TvHeroSection(movies: movies),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            subteamAsync.when(
                              data: (subteam) => TvRow(title: 'Subteam', movies: subteam),
                              loading: () => const TvLoadingGrid(),
                              error: (_, _) => const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 40),
                            TvRow(title: 'Phim mới cập nhật', movies: movies),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Column(
                  children: [
                    const SizedBox(height: 32),
                    const TvHeroLoading(),
                    const SizedBox(height: 48),
                    const TvLoadingGrid(),
                  ],
                ),
                error: (e, _) => _buildError(ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie_outlined, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text(
            'Chưa có phim nào',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 20),
          ),
          const SizedBox(height: 16),
          _RetryButton(onRetry: () {
            ref.invalidate(newMoviesProvider);
            ref.invalidate(subteamProvider);
          }),
        ],
      ),
    );
  }

  Widget _buildError(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text(
            'Không thể tải dữ liệu',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 20),
          ),
          const SizedBox(height: 16),
          _RetryButton(onRetry: () {
            ref.invalidate(newMoviesProvider);
            ref.invalidate(subteamProvider);
          }),
        ],
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final VoidCallback onRetry;

  const _RetryButton({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (ctx) {
        final focused = Focus.of(ctx).hasFocus;
        return GestureDetector(
          onTap: onRetry,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            decoration: BoxDecoration(
              gradient: focused
                  ? const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd])
                  : LinearGradient(
                      colors: [AppColors.gradientStart.withValues(alpha: 0.5), AppColors.gradientMid.withValues(alpha: 0.5)],
                    ),
              borderRadius: BorderRadius.circular(12),
              border: focused ? Border.all(color: AppColors.gradientMid, width: 2) : null,
            ),
            child: const Text(
              'Thử lại',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }),
    );
  }
}
