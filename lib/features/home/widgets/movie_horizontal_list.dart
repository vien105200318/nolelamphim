import 'package:flutter/material.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_panel.dart';
import 'movie_card.dart';

class MovieHorizontalList extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final MovieDot? dot;

  const MovieHorizontalList({
    super.key,
    required this.title,
    required this.movies,
    this.dot,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: GlassPanel(
            blur: 6,
            borderOpacity: 0.06,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.accentGradient,
                  ),
                  borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, index) => SizedBox(
              width: 140,
              child: MovieCard(movie: movies[index], dot: dot),
            ),
          ),
        ),
      ],
    );
  }
}
