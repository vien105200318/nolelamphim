import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/episode.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_pagination.dart';
import '../../../shared/widgets/glass_panel.dart';

/// Danh sách tập — spec §5.4.
/// - Nhiều server: tab kính ngang, tab active = gradient + viền tím,
///   phải: "N tập" (muted 11px).
/// - Grid tập trong content-card (48px mobile / 56px desktop).
/// - Phân trang theo server, `PER_PAGE = 24` tập/trang.
class EpisodeList extends StatefulWidget {
  final String movieSlug;
  final String movieName;
  final List<EpisodeServer> servers;

  const EpisodeList({
    super.key,
    required this.movieSlug,
    required this.movieName,
    required this.servers,
  });

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  static const _perPage = 24;

  int _selectedServer = 0;
  int _episodePage = 1;

  int get _totalEpisodes => widget.servers
      .fold<int>(0, (sum, s) => sum + s.serverData.length);

  int get _pageCount {
    final server = widget.servers[_selectedServer];
    final total = server.serverData.length;
    return total <= _perPage ? 1 : (total / _perPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.servers.isEmpty) return const SizedBox.shrink();

    final server = widget.servers[_selectedServer];
    final dataWidth = MediaQuery.of(context).size.width;

    final start = (_episodePage - 1) * _perPage;
    final visible =
        server.serverData.skip(start).take(_perPage).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.servers.length > 1) ...[
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.servers.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final isSelected = index == _selectedServer;
                      return GlassTile(
                        active: isSelected,
                        radius: 10,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        height: 36,
                        onTap: () {
                          if (_selectedServer == index) return;
                          setState(() {
                            _selectedServer = index;
                            _episodePage = 1;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.servers[index].serverName.trim(),
                              style: TextStyle(
                                fontSize: 12.5,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.gradientMid,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$_totalEpisodes tập',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        ContentCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: visible.map((ep) {
                  final size = dataWidth > 600 ? 56.0 : 48.0;
                  return SizedBox(
                    width: size,
                    height: size,
                    child: GlassTile(
                      radius: 8,
                      padding: EdgeInsets.zero,
                      height: size,
                      onTap: () {
                        context.push('/xem/${widget.movieSlug}/${ep.slug}',
                            extra: widget.movieName);
                      },
                      child: Text(
                        ep.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        GlassPagination(
          page: _episodePage,
          totalPages: _pageCount,
          onPageChanged: (p) => setState(() => _episodePage = p),
        ),
      ],
    );
  }
}
