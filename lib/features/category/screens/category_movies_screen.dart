import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import '../../home/widgets/movie_card.dart';
import '../providers/category_provider.dart';

class CategoryMoviesScreen extends ConsumerWidget {
  final String type;
  final String slug;
  final String title;

  const CategoryMoviesScreen({
    super.key,
    required this.type,
    required this.slug,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = _getProvider(ref);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/category'),
        ),
      ),
      body: provider.when(
        data: (movies) => _buildGrid(context, movies),
        loading: () => const _MovieGridLoading(),
        error: (_, _) => _buildError(),
      ),
    );
  }

  AsyncValue<List<Movie>> _getProvider(WidgetRef ref) {
    switch (type) {
      case 'the-loai':
        return ref.watch(categoryMoviesProvider(slug));
      case 'quoc-gia':
        return ref.watch(countryMoviesProvider(slug));
      case 'nam':
        return ref.watch(yearMoviesProvider(slug));
      default:
        return const AsyncValue.data([]);
    }
  }

  Widget _buildGrid(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'Không có phim nào',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.65,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) => MovieCard(movie: movies[index]),
        );
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          const Text(
            'Có lỗi xảy ra',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _MovieGridLoading extends StatelessWidget {
  const _MovieGridLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
