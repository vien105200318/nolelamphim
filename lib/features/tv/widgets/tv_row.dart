import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import 'tv_movie_card.dart';

class TvRow extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const TvRow({super.key, required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, i) => TvMovieCard(movie: movies[i]),
          ),
        ),
      ],
    );
  }
}
