import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';

/// Khối "Chủ đề" — hàng ngang các thẻ kính (ảnh + gradient + nhãn),
/// khớp web `ThemeSection.astro`.
class ThemeSection extends ConsumerWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Chủ đề',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Khám phá theo sở thích',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 128,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: themeConfigs.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _ThemeCard(index: i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends ConsumerWidget {
  final int index;

  const _ThemeCard({required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = themeConfigs[index];
    final moviesAsync = ref.watch(themeMoviesProvider(index));

    return SizedBox(
      width: 190,
      child: GestureDetector(
        onTap: () => _open(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: -6,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.18),
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                moviesAsync.when(
                  data: (movies) => _thumb(context, movies),
                  loading: () => Container(color: AppColors.bgCard),
                  error: (_, _) => Container(color: AppColors.bgCard),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: config.gradient,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x33000000),
                        Colors.transparent,
                        Color(0xB3000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        config.sub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumb(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) return Container(color: AppColors.bgCard);
    final movie = movies.first;
    return CachedNetworkImage(
      imageUrl: movie.posterUrl ?? movie.thumbUrl ?? '',
      fit: BoxFit.cover,
      errorWidget: (_, _, _) => Container(color: AppColors.bgCard),
    );
  }

  void _open(BuildContext context) {
    final config = themeConfigs[index];
    if (config.categorySlug != null) {
      context.push('/category/the-loai/${config.categorySlug}');
    } else if (config.searchQuery != null) {
      context.push('/search', extra: config.searchQuery);
    } else {
      context.push('/search');
    }
  }
}
