import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/providers/favorites_provider.dart';

class MovieCard extends ConsumerWidget {
  final Movie movie;
  final double? width;
  final double? height;

  const MovieCard({
    super.key,
    required this.movie,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider.select((list) => list.any((m) => m.id == movie.id)));
    return GestureDetector(
      onTap: () => context.push('/phim/${movie.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.thumbUrl ?? '',
                    width: width,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Shimmer.fromColors(
                      baseColor: AppColors.bgCard,
                      highlightColor: AppColors.bgSurface,
                      child: Container(color: AppColors.bgCard),
                    ),
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.bgCard,
                      child: const Icon(Icons.movie, color: AppColors.textMuted),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => ref.read(favoritesProvider.notifier).toggle(movie),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            movie.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (movie.year != null)
            Text(
              '${movie.year}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}
