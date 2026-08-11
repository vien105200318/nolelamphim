import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import '../../../shared/widgets/app_network_image.dart';

class TvHeroSection extends StatefulWidget {
  final List<Movie> movies;

  const TvHeroSection({super.key, required this.movies});

  @override
  State<TvHeroSection> createState() => _TvHeroSectionState();
}

class _TvHeroSectionState extends State<TvHeroSection> {
  final _pageController = PageController(viewportFraction: 0.95);
  final _focusNode = FocusNode();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.movies.take(5).toList();
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 460,
          child: PageView.builder(
            controller: _pageController,
            itemCount: movies.length,
            itemBuilder: (_, i) => _HeroCard(
              movie: movies[i],
              isActive: i == _currentPage,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(movies.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 32 : 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: isActive
                    ? const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd])
                    : LinearGradient(
                        colors: [AppColors.textMuted.withValues(alpha: 0.3), AppColors.textMuted.withValues(alpha: 0.3)],
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Movie movie;
  final bool isActive;

  const _HeroCard({required this.movie, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Focus(
        child: Builder(builder: (ctx) {
          final focused = Focus.of(ctx).hasFocus;
          return GestureDetector(
            onTap: () => context.push('/phim/${movie.slug}'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: focused
                    ? Border.all(color: AppColors.gradientMid, width: 3)
                    : Border.all(color: Colors.transparent),
                boxShadow: focused
                    ? [
                        BoxShadow(
                          color: AppColors.gradientMid.withValues(alpha: 0.3),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(focused ? 17 : 20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      imageUrl: movie.posterUrl ?? movie.thumbUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (_) => Container(color: AppColors.bgCard),
                      error: (_) => Container(
                        color: AppColors.bgCard,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.movie, color: AppColors.textMuted, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'No poster',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            AppColors.bgDark.withValues(alpha: 0.6),
                            AppColors.bgDark.withValues(alpha: 0.95),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      right: 40,
                      bottom: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (movie.quality != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.gradientMid.withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    movie.quality!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 10),
                              if (movie.year != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${movie.year}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              if (movie.lang != null) ...[
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    movie.lang!,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            movie.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (movie.originName != null && movie.originName!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              movie.originName!,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 20),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            decoration: BoxDecoration(
                              gradient: focused
                                  ? const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd])
                                  : LinearGradient(
                                      colors: [
                                        AppColors.gradientStart.withValues(alpha: 0.8),
                                        AppColors.gradientMid.withValues(alpha: 0.8),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: focused
                                  ? [BoxShadow(color: AppColors.gradientMid.withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 1)]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: focused ? 30 : 26,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Xem ngay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgDark.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: AppColors.accentGold, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              'NỔI BẬT',
                              style: TextStyle(
                                color: AppColors.accentGold,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
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
        }),
      ),
    );
  }
}
