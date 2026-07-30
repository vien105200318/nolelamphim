import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';

class TvMovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;

  const TvMovieCard({
    super.key,
    required this.movie,
    this.width = 200,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (ctx) {
        final focused = Focus.of(ctx).hasFocus;
        return GestureDetector(
          onTap: () => context.push('/phim/${movie.slug}'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width,
            height: height,
            margin: focused ? EdgeInsets.zero : const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: focused
                  ? Border.all(color: AppColors.gradientMid, width: 3)
                  : Border.all(color: Colors.transparent, width: 3),
              boxShadow: focused
                  ? [BoxShadow(color: AppColors.gradientMid.withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 2)]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.thumbUrl ?? movie.posterUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(color: AppColors.bgCard),
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.bgCard,
                      child: const Icon(Icons.movie, color: AppColors.textMuted, size: 32),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                        ),
                      ),
                      child: Text(
                        movie.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (movie.quality != null || movie.year != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gradientMid.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          movie.quality ?? '${movie.year}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
