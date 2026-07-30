import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../favorites/providers/history_provider.dart';
import '../providers/watch_provider.dart';
import '../widgets/video_player_widget.dart';

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
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final videoUrl = ref.watch(watchProvider(
      WatchParams(movieSlug: widget.slug, episodeSlug: widget.episode),
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: videoUrl.when(
        data: (url) {
          if (url == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.videocam_off,
                      size: 48, color: Colors.white38),
                  const SizedBox(height: 12),
                  const Text(
                    'Không tìm thấy tập phim',
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        ref.invalidate(watchProvider(WatchParams(
                      movieSlug: widget.slug,
                      episodeSlug: widget.episode,
                    ))),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_saved) {
              _saved = true;
              ref.read(historyProvider.notifier).add(HistoryItem(
                id: 0,
                slug: widget.slug,
                name: widget.movieName,
                episode: widget.episode,
                watchedAt: DateTime.now().millisecondsSinceEpoch,
              ));
            }
          });
          return VideoPlayerWidget(
            url: url,
            movieName: widget.movieName,
            episode: widget.episode,
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white38),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: Colors.white38),
              const SizedBox(height: 12),
              Text(
                'Lỗi: $e',
                style: const TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(watchProvider(WatchParams(
                  movieSlug: widget.slug,
                  episodeSlug: widget.episode,
                ))),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}