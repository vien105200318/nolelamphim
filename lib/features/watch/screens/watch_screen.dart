import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/episode.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../favorites/providers/history_provider.dart';
import '../../movie_detail/widgets/report_button.dart';
import '../providers/watch_provider.dart';
import '../widgets/video_player_widget.dart';

/// Trang xem phim — spec §5.5: player 16:9 (poster + play trước, video_player
/// m3u8 khi bấm), breadcrumb + h1, server tabs, điều hướng tập, tự thêm recent.
class WatchScreen extends ConsumerStatefulWidget {
  final String slug;
  final String episode;
  final String movieName;

  const WatchScreen({
    super.key,
    required this.slug,
    required this.episode,
    required this.movieName,
  });

  @override
  ConsumerState<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen> {
  int _serverIndex = 0;
  bool _started = false;
  bool _saved = false;

  String get _episodeSlug => widget.episode;

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(watchDataProvider(
      WatchParams(movieSlug: widget.slug, episodeSlug: widget.episode),
    ));

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: dataAsync.when(
        data: (data) {
          if (data == null) {
            return _buildNotFound();
          }
          _saveRecent(data);
          final movie = data.movie;
          final server = movie.episodes[_serverIndex];
          final episodes = server.serverData;
          var epIdx = episodes.indexWhere((e) => e.slug == _episodeSlug);
          if (epIdx < 0) epIdx = 0;
          final currentEp = episodes[epIdx];
          final prevEp = epIdx > 0 ? episodes[epIdx - 1] : null;
          final nextEp = epIdx < episodes.length - 1 ? episodes[epIdx + 1] : null;
          final url = resolveStreamUrl(currentEp.linkEmbed);

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(watchDataProvider(
              WatchParams(movieSlug: widget.slug, episodeSlug: widget.episode),
            )),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlayer(context, movie.thumbUrl ?? movie.posterUrl ?? '', url, nextEp),
                  const SizedBox(height: 14),
                  _buildBreadcrumb(context, movie.name, currentEp.name),
                  if (movie.episodes.length > 1) ...[
                    const SizedBox(height: 12),
                    _buildServerTabs(movie.episodes),
                  ],
                  const SizedBox(height: 12),
                  _buildEpisodeNav(context, movie.name, prevEp, nextEp),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gradientMid),
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
                onPressed: () => ref.invalidate(watchDataProvider(
                  WatchParams(
                      movieSlug: widget.slug, episodeSlug: widget.episode),
                )),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRecent(WatchData data) {
    if (_saved || !mounted) return;
    _saved = true;
    final movie = data.movie;
    final server = movie.episodes[data.serverIndex].serverData;
    final ep = data.episodeIndex < server.length ? server[data.episodeIndex] : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).add(HistoryItem(
            id: movie.id,
            slug: movie.slug,
            name: movie.name,
            thumbUrl: movie.thumbUrl,
            episode: ep?.name ?? _episodeSlug,
            episodeSlug: _episodeSlug,
            tmdbVote: movie.tmdb?.voteString,
            watchedAt: DateTime.now().millisecondsSinceEpoch,
          ));
    });
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_off, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          const Text(
            'Không tìm thấy tập phim',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 16),
          GlassTile(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onTap: () => context.push('/phim/${widget.slug}'),
            child: const Text(
              'Quay lại',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer(BuildContext context, String poster,
      String url, EpisodeData? nextEp) {
    return Container(
      decoration: glassFrameDecoration(radius: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Colors.black),
              if (!_started)
                GestureDetector(
                  onTap: () => setState(() => _started = true),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (poster.isNotEmpty)
                        AppNetworkImage(
                          imageUrl: poster,
                          fit: BoxFit.cover,
                          error: (_) => Container(color: Colors.black),
                        ),
                      Container(color: Colors.black.withValues(alpha: 0.35)),
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: GlassStyle.whiteGradient(const [0.2, 0.06, 0.12]),
                            color: AppColors.glassBackdrop.withValues(alpha: 0.9),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.26)),
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 38),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient:
                                  GlassStyle.whiteGradient(const [0.09, 0.025, 0.05]),
                              color: AppColors.glassBackdrop,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.13)),
                            ),
                            child: const Text(
                              'Bấm để phát',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                VideoPlayerWidget(
                  url: url,
                  movieName: widget.movieName,
                  episode: currentEpisodeName(),
                ),
              if (nextEp != null)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => context.push(
                        '/xem/${widget.slug}/${nextEp.slug}',
                        extra: widget.movieName),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient:
                            GlassStyle.whiteGradient(const [0.09, 0.025, 0.05]),
                        color: AppColors.glassBackdrop.withValues(alpha: 0.9),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.13)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            nextEp.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String currentEpisodeName() {
    final data = ref.read(watchDataProvider(
      WatchParams(movieSlug: widget.slug, episodeSlug: _episodeSlug),
    )).valueOrNull;
    if (data == null) return _episodeSlug;
    final list = data.movie.episodes[_serverIndex].serverData;
    final idx = list.indexWhere((e) => e.slug == _episodeSlug);
    if (idx < 0 || idx >= list.length) return _episodeSlug;
    return list[idx].name;
  }

  Widget _buildBreadcrumb(BuildContext context, String movieName, String epName) {
    return ContentCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              GestureDetector(
                onTap: () => context.go('/'),
                child: const Text(
                  'Trang chủ',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
              const Text('/', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              GestureDetector(
                onTap: () => context.push('/phim/${widget.slug}'),
                child: Text(
                  movieName,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Text('/', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Text(
                epName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$movieName - $epName',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerTabs(List<EpisodeServer> servers) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: servers.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final isSelected = index == _serverIndex;
          return GlassTile(
            active: isSelected,
            radius: 10,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            height: 36,
            onTap: () => setState(() => _serverIndex = index),
            child: Text(
              servers[index].serverName.trim(),
              style: TextStyle(
                fontSize: 12.5,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodeNav(BuildContext context, String movieName,
      EpisodeData? prevEp, EpisodeData? nextEp) {
    return LiquidGlassPanel(
      radius: 18,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _navButton(
                  enabled: prevEp != null,
                  icon: Icons.skip_previous_rounded,
                  label: prevEp != null ? prevEp.name : 'Hết',
                  onTap: prevEp == null
                      ? null
                      : () => context.push('/xem/${widget.slug}/${prevEp.slug}',
                          extra: movieName),
                ),
              ),
              const SizedBox(width: 8),
              _navButton(
                enabled: true,
                icon: Icons.view_list_rounded,
                label: 'Danh sách tập',
                onTap: () => context.push('/phim/${widget.slug}'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _navButton(
                  enabled: nextEp != null,
                  icon: Icons.skip_next_rounded,
                  label: nextEp != null ? nextEp.name : 'Hết',
                  onTap: nextEp == null
                      ? null
                      : () => context.push('/xem/${widget.slug}/${nextEp.slug}',
                          extra: movieName),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 6),
          ReportButton(
            slug: widget.slug,
            name: movieName,
            episode: _episodeSlug,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required bool enabled,
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final child = Opacity(
      opacity: enabled ? 1 : 0.4,
      child: GlassTile(
        radius: 12,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        active: enabled,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16,
                color: enabled ? Colors.white : AppColors.textMuted),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: enabled ? Colors.white : AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: enabled ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (!enabled) return IgnorePointer(child: child);
    return child;
  }
}
