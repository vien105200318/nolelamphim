import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_image_cache.dart';

/// Hero carousel mobile — khớp web `HeroCarousel.astro`:
/// tự chạy (autoplay), overlay gradient dưới lên, pill "Nổi bật · năm"
/// gradient hồng→tím→xanh, nút "Xem ngay" kính + pill chất lượng, dấu chấm.
class HeroCarousel extends StatefulWidget {
  final List<Movie> movies;

  const HeroCarousel({super.key, required this.movies});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  static const _autoplayMs = 5000;

  late final PageController _controller;
  Timer? _timer;
  int _active = 0;
  bool _paused = false;
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _itemCount = widget.movies.length > 8 ? 8 : widget.movies.length;
    _controller = PageController();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant HeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movies != widget.movies) {
      _itemCount = widget.movies.length > 8 ? 8 : widget.movies.length;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_paused || _itemCount <= 1) return;
    _timer = Timer.periodic(
      const Duration(milliseconds: _autoplayMs),
      (_) => _go(1),
    );
  }

  void _go(int dir) {
    if (_itemCount == 0) return;
    final next = (_active + dir + _itemCount) % _itemCount;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _active = index);
  }

  void _onHoverChanged(bool hovering) {
    setState(() => _paused = hovering);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.32;
    final movies = widget.movies.take(_itemCount).toList();

    return Column(
      children: [
        SizedBox(
          height: height,
          child: MouseRegion(
            onEnter: (_) => _onHoverChanged(true),
            onExit: (_) => _onHoverChanged(false),
            child: PageView.builder(
              controller: _controller,
              onPageChanged: _onPageChanged,
              itemCount: _itemCount,
              itemBuilder: (_, index) => _HeroSlide(
                movie: movies[index],
                onTap: () => context.push('/phim/${movies[index].slug}'),
              ),
            ),
          ),
        ),
        if (movies.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(movies.length, (i) {
                final selected = i == _active;
                return GestureDetector(
                  onTap: () => _controller.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: selected ? 36 : 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: selected
                          ? const LinearGradient(
                              colors: [
                                AppColors.gradientStart,
                                AppColors.gradientEnd,
                              ],
                            )
                          : null,
                      color: selected
                          ? null
                          : Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _HeroSlide({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = movie.posterUrl ?? movie.thumbUrl ?? '';
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                cacheManager: AppImageCache.instance,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: AppColors.bgCard,
                  child: const Center(
                    child: Icon(
                      Icons.movie,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  color: AppColors.bgCard,
                  child: const Center(
                    child: Icon(
                      Icons.movie,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x400A0A14),
                      AppColors.bgDark,
                    ],
                    stops: [0.35, 0.6, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GradientPill(
                        text: movie.year != null
                            ? 'Nổi bật · ${movie.year}'
                            : 'Nổi bật',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      if (movie.originName != null &&
                          movie.originName!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            movie.originName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              shadows: const [
                                Shadow(color: Colors.black54, blurRadius: 6),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Xem ngay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (movie.quality != null &&
                              movie.quality!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Text(
                                  movie.quality!,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientPill extends StatelessWidget {
  final String text;

  const _GradientPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.gradientStart,
            AppColors.gradientMid,
            AppColors.gradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientMid.withValues(alpha: 0.25),
            blurRadius: 12,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
