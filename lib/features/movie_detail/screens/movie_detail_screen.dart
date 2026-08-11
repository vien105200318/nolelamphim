import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/movie_detail.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../providers/movie_detail_provider.dart';
import '../widgets/episode_list.dart';
import '../widgets/rating_box.dart';
import '../widgets/report_button.dart';
import '../widgets/share_button.dart';
import '../widgets/similar_movies.dart';

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
          return _DetailBody(movie: movie, slug: slug);
        },
        loading: () => const _DetailLoadingShimmer(),
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
}

class _DetailBody extends ConsumerWidget {
  final MovieDetail movie;
  final String slug;

  const _DetailBody({required this.movie, required this.slug});

  String get _banner => movie.posterUrl ?? movie.thumbUrl ?? '';

  String _formatViewCount(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
    return '$v';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(movieDetailProvider(slug)),
      child: CustomScrollView(
        slivers: [
          _buildBanner(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(context, ref),
                  const SizedBox(height: 12),
                  _buildActionsRow(context, ref),
                  const SizedBox(height: 16),
                  _buildMetaRow(),
                  if (movie.content != null && movie.content!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSection('Nội dung', movie.content!),
                  ],
                  if (movie.actors.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSection('Diễn viên', movie.actors.join(', ')),
                  ],
                  if (movie.directors.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSection('Đạo diễn', movie.directors.join(', ')),
                  ],
                  if (movie.categories.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('Thể loại'),
                    const SizedBox(height: 8),
                    _buildCategoryChips(context),
                  ],
                  if (movie.keywords.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _buildKeywords(context),
                  ],
                  if (movie.episodes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('Tập phim'),
                    const SizedBox(height: 10),
                    EpisodeList(
                      movieSlug: slug,
                      movieName: movie.name,
                      servers: movie.episodes,
                    ),
                  ],
                  SimilarMovies(slug: slug),
                  const SizedBox(height: 24),
                  _buildBackButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.32,
      pinned: true,
      backgroundColor: AppColors.bgDark,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x17FFFFFF), Color(0x06FFFFFF)],
                ),
                color: AppColors.glassBackdrop,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 16, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _banner,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Container(
                color: AppColors.bgCard,
                child: const Icon(Icons.movie,
                    size: 64, color: AppColors.textMuted),
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

  Widget _buildTitleRow(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (movie.originName != null && movie.originName!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              movie.originName!,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionsRow(BuildContext context, WidgetRef ref) {
    final tmdb = movie.tmdb;
    final movieModel = Movie(
      id: movie.id,
      name: movie.name,
      slug: movie.slug,
      posterUrl: movie.posterUrl,
      thumbUrl: movie.thumbUrl,
      year: movie.year,
      tmdb: tmdb,
    );
    final trailerId = _youtubeId(movie.trailerUrl);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (trailerId != null)
          GestureDetector(
            onTap: () => launchUrl(
              Uri.parse('https://www.youtube.com/watch?v=$trailerId'),
              mode: LaunchMode.externalApplication,
            ),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x17FFFFFF), Color(0x06FFFFFF)],
                ),
                color: AppColors.glassBackdrop,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded,
                      size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 4),
                  Text(
                    'Trailer',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        RatingBox(slug: slug, name: movie.name),
        ShareButton(slug: slug, name: movie.name),
        ReportButton(slug: slug, name: movie.name),
        _buildFavoriteButton(context, ref, movieModel),
      ],
    );
  }

  Widget _buildFavoriteButton(
      BuildContext context, WidgetRef ref, Movie movieModel) {
    final isFav = ref
        .watch(favoritesProvider.select((list) => list.any((m) => m.id == movie.id)));
    return GestureDetector(
      onTap: () => ref.read(favoritesProvider.notifier).toggle(movieModel),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isFav
              ? const LinearGradient(
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientMid,
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x17FFFFFF), Color(0x06FFFFFF)],
                ),
          color: isFav ? null : AppColors.glassBackdrop,
          border: Border.all(
            color: isFav ? Colors.transparent : AppColors.glassBorder,
          ),
          boxShadow: isFav
              ? [
                  BoxShadow(
                    color: AppColors.gradientStart.withValues(alpha: 0.35),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 17,
          color: isFav ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMetaRow() {
    final chips = <Widget>[
      if (movie.year != null) _buildChip('${movie.year}'),
      if (movie.quality != null && movie.quality!.isNotEmpty)
        _buildChip(movie.quality!),
      if (movie.lang != null && movie.lang!.isNotEmpty) _buildChip(movie.lang!),
      if (movie.time != null && movie.time!.isNotEmpty) _buildChip(movie.time!),
      if (movie.status != null && movie.status!.isNotEmpty)
        _buildChip(movie.status!),
      if (movie.view != null && movie.view! > 0)
        _buildChip('${_formatViewCount(movie.view!)} lượt xem'),
    ];

    final vote = movie.tmdb?.voteString;
    final imdbId = movie.imdb.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: 8, runSpacing: 8, children: chips),
        if (vote != null || imdbId != null || (movie.subDocquyen ?? false) ||
            (movie.episodeCurrent != null && movie.episodeCurrent!.isNotEmpty))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (vote != null) _buildChip('★ TMDB $vote'),
                if (imdbId != null && imdbId.isNotEmpty)
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse('https://www.imdb.com/title/$imdbId'),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: _buildChip('IMDb'),
                  ),
                if (movie.subDocquyen ?? false) _buildPinkChip('Vietsub độc quyền'),
                if (movie.episodeCurrent != null &&
                    movie.episodeCurrent!.isNotEmpty)
                  _buildPinkChip(movie.episodeCurrent!),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return GlassChip(
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPinkChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0x26FF6B9D), Color(0x264A9EFF)],
        ),
        border: Border.all(
          color: AppColors.gradientStart.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.gradientStart,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: movie.categories.map((cat) {
        return GlassTile(
          radius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          onTap: () => context.push('/category/the-loai/${cat.slug}'),
          child: Text(
            cat.name,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeywords(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: movie.keywords.take(10).map((kw) {
        return GestureDetector(
          onTap: () => context.push('/search', extra: kw),
          child: GlassChip(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            radius: 8,
            child: Text(
              kw,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: GlassTile(
        radius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded,
                size: 16, color: AppColors.textSecondary),
            SizedBox(width: 6),
            Text(
              'Quay lại',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Trích ID YouTube từ trailer_url (hỗ trợ youtu.be, watch?v=, /embed/).
  static String? _youtubeId(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final host = uri.host.toLowerCase();

    if (host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }
    if (host == 'youtube-nocookie.com' || host.endsWith('youtube.com')) {
      final segs = uri.pathSegments;
      if (segs.isNotEmpty && segs.first == 'embed' && segs.length > 1) {
        return segs[1];
      }
      final v = uri.queryParameters['v'];
      if (v != null && v.isNotEmpty) return v;
      if (segs.isNotEmpty) return segs.first;
    }
    return null;
  }
}

class _DetailLoadingShimmer extends StatelessWidget {
  const _DetailLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
            color: AppColors.bgCard,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 20,
                  color: AppColors.bgCard,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 16,
                  color: AppColors.bgCard,
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(
                    3,
                    (_) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 80,
                  height: 16,
                  color: AppColors.bgCard,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 14,
                  color: AppColors.bgCard,
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 14,
                  color: AppColors.bgCard,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 150,
                  height: 14,
                  color: AppColors.bgCard,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
