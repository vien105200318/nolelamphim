import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import 'tv_movie_card.dart';

class TvRow extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final String? subtitle;

  const TvRow({super.key, required this.title, required this.movies, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                gradient: LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 12),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 15,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, i) => TvMovieCard(movie: movies[i]),
          ),
        ),
      ],
    );
  }
}
