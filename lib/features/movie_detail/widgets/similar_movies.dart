import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/widgets/movie_card.dart';
import '../providers/movie_detail_provider.dart';

/// "Phim tương tự" — spec §5.2 (10): lưới tối đa 6 card, 2 cột mobile.
class SimilarMovies extends ConsumerWidget {
  final String slug;

  const SimilarMovies({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(similarMoviesProvider(slug));

    return moviesAsync.when(
      data: (movies) {
        if (movies.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Phim tương tự',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 14,
                ),
                itemCount: movies.length,
                itemBuilder: (_, i) => MovieCard(movie: movies[i]),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
