import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';
import '../../watch/providers/watch_provider.dart';

class TvWatchScreen extends ConsumerStatefulWidget {
  final String slug;
  final String episode;
  final String movieName;

  const TvWatchScreen({
    super.key,
    required this.slug,
    required this.episode,
    required this.movieName,
  });

  @override
  ConsumerState<TvWatchScreen> createState() => _TvWatchScreenState();
}

class _TvWatchScreenState extends ConsumerState<TvWatchScreen> {
  VideoPlayerController? _controller;
  bool _isReady = false;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final params = WatchParams(movieSlug: widget.slug, episodeSlug: widget.episode);
    final url = await ref.read(watchProvider(params).future);
    if (url == null || url.isEmpty) return;

    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) return;

      final controller = VideoPlayerController.networkUrl(uri);
      await controller.initialize();
      controller.play();

      if (mounted) {
        setState(() {
          _controller = controller;
          _isReady = true;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.gradientMid),
              const SizedBox(height: 20),
              Text(widget.movieName,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 20)),
              const SizedBox(height: 8),
              const Text('Đang tải...',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          if (_controlsVisible)
            GestureDetector(
              onTap: _toggleControls,
              child: Container(
                color: Colors.black26,
                child: _TvControls(
                  controller: _controller!,
                  onBack: () => context.pop(),
                  onTogglePlay: () {
                    setState(() {
                      if (_controller!.value.isPlaying) {
                        _controller!.pause();
                      } else {
                        _controller!.play();
                      }
                    });
                  },
                  onSeekForward: () {
                    final pos = _controller!.value.position;
                    _controller!.seekTo(pos + const Duration(seconds: 30));
                  },
                  onSeekBackward: () {
                    final pos = _controller!.value.position;
                    final newPos = pos - const Duration(seconds: 10);
                    _controller!.seekTo(newPos > Duration.zero ? newPos : Duration.zero);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TvControls extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onBack;
  final VoidCallback onTogglePlay;
  final VoidCallback onSeekForward;
  final VoidCallback onSeekBackward;

  const _TvControls({
    required this.controller,
    required this.onBack,
    required this.onTogglePlay,
    required this.onSeekForward,
    required this.onSeekBackward,
  });

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    final position = value.position;
    final duration = value.duration;
    final isPlaying = value.isPlaying;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ControlButton(icon: Icons.replay_10, label: 'Tua lùi', onPressed: onSeekBackward),
            const SizedBox(width: 40),
            _ControlButton(
              icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              label: isPlaying ? 'Tạm dừng' : 'Phát',
              onPressed: onTogglePlay,
              large: true,
            ),
            const SizedBox(width: 40),
            _ControlButton(icon: Icons.forward_30, label: 'Tua tới', onPressed: onSeekForward),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: [
              VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding: const EdgeInsets.only(bottom: 8),
                colors: const VideoProgressColors(
                  playedColor: AppColors.gradientMid,
                  bufferedColor: AppColors.glassWhite,
                  backgroundColor: Color(0x33FFFFFF),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.play_arrow, color: AppColors.textMuted, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '/ ${_formatDuration(duration)}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                          SizedBox(width: 6),
                          Text('Thoát', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool large;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (ctx) {
        final focused = Focus.of(ctx).hasFocus;
        return GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: large ? 72 : 56,
            height: large ? 72 : 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: focused ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
              border: focused ? Border.all(color: Colors.white, width: 2) : null,
            ),
            child: Icon(icon, color: Colors.white, size: large ? 36 : 28),
          ),
        );
      }),
    );
  }
}
