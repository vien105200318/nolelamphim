import 'package:flutter/material.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_panel.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final MovieDot? dot;
  final Widget? footer;

  const MovieGrid({
    super.key,
    required this.movies,
    this.dot,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200
        ? 6
        : width > 800
            ? 4
            : width > 600
                ? 3
                : 2;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.58,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
      ),
      itemCount: movies.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => MovieCard(movie: movies[index], dot: dot),
    );
  }
}

/// Nút "Xem thêm" phân trang (footer grid phim mới).
class LoadMoreButton extends StatelessWidget {
  final bool loading;
  final bool hasMore;
  final VoidCallback onTap;

  const LoadMoreButton({
    super.key,
    required this.loading,
    required this.hasMore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Text(
            'Đã hiển thị tất cả',
            style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7)),
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.gradientEnd,
                ),
              )
            : GlassTile(
                radius: 20,
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                onTap: onTap,
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }
}
