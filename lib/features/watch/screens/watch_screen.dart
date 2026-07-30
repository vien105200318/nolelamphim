import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/providers/history_provider.dart';
import '../providers/watch_provider.dart';
import '../widgets/video_player_widget.dart';

class WatchScreen extends ConsumerStatefulWidget {
  final String slug;
  final String episode;

  const WatchScreen({
    super.key,
    required this.slug,
    required this.episode,
  });

  @override
  ConsumerState<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final videoUrl = ref.watch(watchProvider(
      WatchParams(movieSlug: widget.slug, episodeSlug: widget.episode),
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.episode),
      ),
      body: videoUrl.when(
        data: (url) {
          if (url == null) {
            return const Center(
              child: Text(
                'Không tìm thấy tập phim',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_saved) {
              _saved = true;
              ref.read(historyProvider.notifier).add(HistoryItem(
                id: 0,
                slug: widget.slug,
                name: widget.slug,
                episode: widget.episode,
                watchedAt: DateTime.now().millisecondsSinceEpoch,
              ));
            }
          });
          return VideoPlayerWidget(url: url);
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
              Text(
                'Lỗi: $e',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
