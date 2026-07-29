import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';

class MovieCarousel extends StatelessWidget {
  final List<Movie> movies;

  const MovieCarousel({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.28;

    return SizedBox(
      height: height,
      child: PageView.builder(
        itemCount: movies.length > 10 ? 10 : movies.length,
        itemBuilder: (_, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => context.push('/phim/${movie.slug}'),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: movie.posterUrl ?? movie.thumbUrl ?? '',
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.bgCard,
                    child: const Icon(Icons.movie,
                        size: 48, color: AppColors.textMuted),
                  ),
                ),
                Container(
                  height: height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.bgDark],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (movie.year != null)
                        Text(
                          '${movie.year}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
