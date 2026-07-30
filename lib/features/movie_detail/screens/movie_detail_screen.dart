import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/episode.dart';
import '../../../core/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../providers/movie_detail_provider.dart';
import '../widgets/episode_list.dart';

class MovieDetailScreen extends ConsumerWidget {
  final String slug;

  const MovieDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(movieDetailProvider(slug));

    return Scaffold(
      body: detailAsync.when(
        data: (data) {
          final movie = data.movie;
          if (movie == null) {
            return const Center(child: Text('Không tìm thấy phim'));
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, movie.posterUrl ?? movie.thumbUrl ?? ''),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(movie),
                      const SizedBox(height: 12),
                      _buildMetaRow(movie),
                      const SizedBox(height: 16),
                      if (movie.content != null &&
                          movie.content!.isNotEmpty)
                        _buildSection('Nội dung', movie.content!),
                      if (movie.actors.isNotEmpty)
                        _buildSection('Diễn viên', movie.actors.join(', ')),
                      if (movie.directors.isNotEmpty)
                        _buildSection('Đạo diễn', movie.directors.join(', ')),
                      if (movie.episodes.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildEpisodeSection(movie.episodes),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text('Lỗi: $e',
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(movieDetailProvider(slug)),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, String imageUrl) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.35,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Container(
                color: AppColors.bgCard,
                child:
                    const Icon(Icons.movie, size: 64, color: AppColors.textMuted),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.bgDark],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(dynamic movie) {
    final movieModel = Movie(
      id: movie.id,
      name: movie.name,
      slug: movie.slug,
      posterUrl: movie.posterUrl,
      thumbUrl: movie.thumbUrl,
      year: movie.year,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (movie.originName != null && movie.originName!.isNotEmpty)
                Text(
                  movie.originName!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
        ),
        Consumer(
          builder: (_, ref, __) {
            final isFav = ref.watch(favoritesProvider.select(
                (list) => list.any((m) => m.id == movie.id)));
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : AppColors.textMuted,
                size: 28,
              ),
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(movieModel),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetaRow(dynamic movie) {
    final chips = <Widget>[];
    if (movie.year != null) {
      chips.add(_buildChip('${movie.year}'));
    }
    if (movie.quality != null && movie.quality!.isNotEmpty) {
      chips.add(_buildChip(movie.quality!));
    }
    if (movie.lang != null && movie.lang!.isNotEmpty) {
      chips.add(_buildChip(movie.lang!));
    }
    if (movie.time != null && movie.time!.isNotEmpty) {
      chips.add(_buildChip(movie.time!));
    }
    if (movie.status != null && movie.status!.isNotEmpty) {
      chips.add(_buildChip(movie.status!));
    }
    if (movie.episodeCurrent != null && movie.episodeCurrent!.isNotEmpty) {
      chips.add(_buildChip(movie.episodeCurrent!));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: chips,
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeSection(List<EpisodeServer> episodes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tập phim',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        EpisodeList(movieSlug: slug, servers: episodes),
      ],
    );
  }
}
