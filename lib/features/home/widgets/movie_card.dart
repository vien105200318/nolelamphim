import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/providers/favorites_provider.dart';

enum MovieDot { newMovie, hot }

/// Thẻ phim mobile — khớp markup web `web/src/lib/movieCard.ts`:
/// khung kính (hairline), badge Mới/Hot, badge tập dưới phải,
/// meta `★ 8.5 · 2023 · Full HD · Vietsub`.
class MovieCard extends ConsumerWidget {
  final Movie movie;
  final double? width;
  final double? height;
  final MovieDot? dot;

  const MovieCard({
    super.key,
    required this.movie,
    this.width,
    this.height,
    this.dot,
  });

  String? get _vote => movie.tmdb?.voteString;

  String? get _meta {
    final parts = <String>[
      if (_vote != null) '★ $_vote',
      if (movie.year != null) '${movie.year}',
      if (movie.quality != null && movie.quality!.isNotEmpty) movie.quality!,
      if (movie.lang != null && movie.lang!.isNotEmpty) movie.lang!,
    ];
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select((list) => list.any((m) => m.id == movie.id)),
    );
    return GestureDetector(
      onTap: () => context.push('/phim/${movie.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    spreadRadius: -6,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
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
                        child: const Icon(
                          Icons.movie,
                          color: AppColors.textMuted,
                          size: 28,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () =>
                            ref.read(favoritesProvider.notifier).toggle(movie),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav
                                ? AppColors.gradientStart
                                : Colors.white70,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    if (dot != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _DotBadge(dot: dot!),
                      ),
                    if (movie.episodeCurrent != null &&
                        movie.episodeCurrent!.isNotEmpty)
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            movie.episodeCurrent!,
                            style: const TextStyle(
                              color: Color(0xF2FFFFFF),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
              height: 1.25,
            ),
          ),
          if (_meta != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                _meta!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DotBadge extends StatelessWidget {
  final MovieDot dot;

  const _DotBadge({required this.dot});

  @override
  Widget build(BuildContext context) {
    final isNew = dot == MovieDot.newMovie;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: isNew
            ? null
            : const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColors.gradientStart, AppColors.gradientMid],
              ),
        color: isNew ? AppColors.badgeNew : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isNew
                ? AppColors.badgeNew.withValues(alpha: 0.4)
                : AppColors.gradientMid.withValues(alpha: 0.4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        isNew ? 'Mới' : 'Hot',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
