import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie_detail.dart';
import '../../../core/models/episode.dart';
import '../../movie_detail/providers/movie_detail_provider.dart';
import '../widgets/tv_loading.dart';

class TvMovieDetailScreen extends ConsumerWidget {
  final String slug;

  const TvMovieDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(movieDetailProvider(slug));

    return Container(
      color: AppColors.bgDark,
      child: detailAsync.when(
        data: (response) {
          final movie = response.movie;
          if (movie == null) return _buildNotFound();
          return _buildDetail(context, ref, movie);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gradientMid)),
        error: (e, _) => TvErrorWidget(onRetry: () => ref.invalidate(movieDetailProvider(slug))),
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text('Không tìm thấy phim', style: TextStyle(color: AppColors.textSecondary, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildDetail(BuildContext context, WidgetRef ref, MovieDetail movie) {
    return RawScrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: movie.posterUrl ?? '',
                    width: 360,
                    height: 520,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      width: 360,
                      height: 520,
                      color: AppColors.bgCard,
                    ),
                    errorWidget: (_, _, _) => Container(
                      width: 360,
                      height: 520,
                      color: AppColors.bgCard,
                      child: const Icon(Icons.movie, color: AppColors.textMuted, size: 64),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.name,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      if (movie.originName != null && movie.originName!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          movie.originName!,
                          style: const TextStyle(fontSize: 20, color: AppColors.textMuted),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          if (movie.year != null) _InfoChip(label: '${movie.year}'),
                          if (movie.quality != null) _InfoChip(label: movie.quality!),
                          if (movie.lang != null) _InfoChip(label: movie.lang!),
                          if (movie.time != null) _InfoChip(label: movie.time!),
                          if (movie.status != null && movie.status!.isNotEmpty)
                            _InfoChip(label: movie.status == 'ongoing' ? 'Đang chiếu' : 'Hoàn thành'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (movie.content != null && movie.content!.isNotEmpty) ...[
                        const Text(
                          'Nội dung',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.content!.replaceAll(RegExp(r'<[^>]*>'), ''),
                          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 20),
                      if (movie.directors.isNotEmpty) ...[
                        _MetaRow(label: 'Đạo diễn', value: movie.directors.join(', ')),
                        const SizedBox(height: 8),
                      ],
                      if (movie.actors.isNotEmpty) ...[
                        _MetaRow(label: 'Diễn viên', value: movie.actors.join(', ')),
                        const SizedBox(height: 8),
                      ],
                      if (movie.categories.isNotEmpty) ...[
                        _MetaRow(label: 'Thể loại', value: movie.categories.map((c) => c.name).join(', ')),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 24),
                      if (movie.episodes.isNotEmpty)
                        Focus(
                          child: Builder(builder: (ctx) {
                            final focused = Focus.of(ctx).hasFocus;
                            return GestureDetector(
                              onTap: () => context.push('/xem/$slug/${movie.episodes.first.serverData.first.slug}',
                                  extra: movie.name),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: focused
                                      ? const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd])
                                      : const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd]).scale(0.85),
                                  borderRadius: BorderRadius.circular(14),
                                  border: focused ? Border.all(color: Colors.white, width: 2) : null,
                                  boxShadow: focused
                                      ? [BoxShadow(color: AppColors.gradientMid.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2)]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Xem phim',
                                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (movie.episodes.isNotEmpty) ...[
              const SizedBox(height: 40),
              const Text(
                'Tập phim',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              _EpisodeSection(slug: slug, episodes: movie.episodes),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
    );
  }
}

class _EpisodeSection extends StatelessWidget {
  final String slug;
  final List<EpisodeServer> episodes;

  const _EpisodeSection({required this.slug, required this.episodes});

  @override
  Widget build(BuildContext context) {
    final server = episodes.first;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: server.serverData.map((ep) {
        return Focus(
          child: Builder(builder: (ctx) {
            final focused = Focus.of(ctx).hasFocus;
            return GestureDetector(
              onTap: () => context.push('/xem/$slug/${ep.slug}', extra: ''),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: focused ? AppColors.gradientMid.withValues(alpha: 0.3) : AppColors.glassWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: focused
                      ? Border.all(color: AppColors.gradientMid, width: 2)
                      : Border.all(color: AppColors.glassBorder),
                  boxShadow: focused
                      ? [BoxShadow(color: AppColors.gradientMid.withValues(alpha: 0.3), blurRadius: 12)]
                      : [],
                ),
                child: Text(
                  ep.name,
                  style: TextStyle(
                    color: focused ? AppColors.textPrimary : AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: focused ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}
