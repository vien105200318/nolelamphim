import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_image_cache.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../providers/history_provider.dart';

/// Đã xem / recent — spec §5.8: h1 "Xem gần đây", empty + "Khám phá phim",
/// danh sách hàng, xoá được từng item, điều hướng theo `episodeSlug`.
String _formatDate(int timestamp) {
  if (timestamp == 0) return '';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
  if (diff.inHours < 24) return '${diff.inHours} giờ trước';
  if (diff.inDays < 7) return '${diff.inDays} ngày trước';
  return '${date.day}/${date.month}/${date.year}';
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: const Text('Xem gần đây'),
      ),
      body: list.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: EmptyState(
                icon: Icons.history,
                title: 'Chưa có phim',
                subtitle: 'Phim bạn xem sẽ xuất hiện ở đây',
                actionLabel: 'Khám phá phim',
                onAction: () => context.go('/'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _HistoryRow(
                item: list[i],
                onDelete: () =>
                    ref.read(historyProvider.notifier).remove(list[i].slug),
              ),
            ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onDelete;

  const _HistoryRow({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final meta = <String>[
      if (item.episode.isNotEmpty) item.episode,
      if (item.tmdbVote != null && item.tmdbVote!.isNotEmpty)
        '★ ${item.tmdbVote}',
    ].join(' · ');

    return GestureDetector(
      onTap: () => context
          .push('/xem/${item.slug}/${item.resolveEpisodeSlug}', extra: item.name),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: GlassStyle.whiteGradient(const [0.09, 0.025, 0.05]),
          color: AppColors.glassBackdrop,
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.thumbUrl ?? '',
                cacheManager: AppImageCache.instance,
                width: 56,
                height: 80,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  width: 56,
                  height: 80,
                  color: AppColors.bgCard,
                  child: const Icon(Icons.movie,
                      size: 20, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(item.watchedAt),
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
