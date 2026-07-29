import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/watch_provider.dart';
import '../widgets/video_player_widget.dart';

class WatchScreen extends ConsumerWidget {
  final String slug;
  final String episode;

  const WatchScreen({
    super.key,
    required this.slug,
    required this.episode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoUrl = ref.watch(watchProvider(
      WatchParams(movieSlug: slug, episodeSlug: episode),
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(episode),
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
