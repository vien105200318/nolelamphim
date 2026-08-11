import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../core/pip/pip_service.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/watch_progress_provider.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String url;
  final String movieName;
  final String episode;
  final String movieSlug;
  final String episodeSlug;

  const VideoPlayerWidget({
    super.key,
    required this.url,
    required this.movieName,
    required this.episode,
    required this.movieSlug,
    required this.episodeSlug,
  });

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeFuture;
  bool _controlsVisible = true;
  Timer? _hideTimer;
  bool _isFullscreen = false;
  OverlayEntry? _fullscreenEntry;
  bool _pipAvailable = false;
  final ValueNotifier<double> _speed = ValueNotifier<double>(1.0);
  int _lastSavedSeconds = -1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initializeFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.addListener(_onControllerUpdate);
    _startHideTimer();
    _initPiP();
    _restoreProgress();
  }

  Future<void> _initPiP() async {
    final available = await PiPService.isAvailable;
    if (mounted) setState(() => _pipAvailable = available);
  }

  Future<void> _enterPiP() async {
    final position = _controller.value.position;
    await PiPService.enterPiP(
      videoUrl: widget.url,
      startSeconds: position.inSeconds.toDouble(),
      onExit: () {
        if (mounted) _controller.play();
      },
    );
  }

  Future<void> _restoreProgress() async {
    final saved = ref
        .read(watchProgressProvider.notifier)
        .progress(widget.movieSlug, widget.episodeSlug);
    if (saved == null || saved < 5) return;
    await _initializeFuture;
    if (!mounted) return;
    final duration = _controller.value.duration;
    if (duration.inSeconds > 0 && saved >= duration.inSeconds - 3) return;
    await _controller.seekTo(Duration(seconds: saved));
  }

  void _saveProgress(int seconds) {
    if (seconds <= 5) return;
    final duration = _controller.value.duration;
    if (duration.inSeconds > 0 && seconds >= duration.inSeconds - 5) {
      ref
          .read(watchProgressProvider.notifier)
          .clear(widget.movieSlug, widget.episodeSlug);
      return;
    }
    ref
        .read(watchProgressProvider.notifier)
        .save(widget.movieSlug, widget.episodeSlug, seconds);
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _saveProgress(_controller.value.position.inSeconds);
    }
    _fullscreenEntry?.remove();
    _fullscreenEntry = null;
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _hideTimer?.cancel();
    _speed.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
    final value = _controller.value;
    if (!value.isInitialized) return;
    if (value.isCompleted) {
      ref
          .read(watchProgressProvider.notifier)
          .clear(widget.movieSlug, widget.episodeSlug);
      _lastSavedSeconds = -1;
      return;
    }
    final position = value.position.inSeconds;
    if (position - _lastSavedSeconds >= 5) {
      _lastSavedSeconds = position;
      _saveProgress(position);
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    if (_controller.value.isPlaying) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _controlsVisible = false);
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    if (_controlsVisible) _startHideTimer();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
      _startHideTimer();
    }
  }

  void _setSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
    _speed.value = speed;
    _startHideTimer();
  }

  void _showSpeedMenu() {
    final current = _speed.value;
    const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Tốc độ phát',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...speeds.map((s) {
                final active = s == current;
                return ListTile(
                  dense: true,
                  trailing: active
                      ? const Icon(Icons.check,
                          color: AppColors.gradientStart, size: 20)
                      : null,
                  title: Text(
                    '${s}x',
                    style: TextStyle(
                      color: active
                          ? AppColors.gradientStart
                          : Colors.white,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    _setSpeed(s);
                    Navigator.of(sheetContext).pop();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _toggleFullscreen() {
    if (_isFullscreen) {
      _exitFullscreen();
      return;
    }
    setState(() => _isFullscreen = true);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final entry = OverlayEntry(
      builder: (_) => _FullscreenOverlay(
        controller: _controller,
        movieName: widget.movieName,
        episode: widget.episode,
        pipAvailable: _pipAvailable,
        speed: _speed,
        onPip: _enterPiP,
        onSpeedTap: _showSpeedMenu,
        onExit: _exitFullscreen,
      ),
    );
    _fullscreenEntry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  void _exitFullscreen() {
    _fullscreenEntry?.remove();
    _fullscreenEntry = null;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (mounted) setState(() => _isFullscreen = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) {
      return const ColoredBox(color: Colors.black);
    }
    return FutureBuilder(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: Colors.white54),
                const SizedBox(height: 8),
                Text(
                  'Không thể phát video',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              if (_controlsVisible) ...[
                _PlayerTopBar(
                  movieName: widget.movieName,
                  episode: widget.episode,
                  addSystemTopInset: false,
                  onBack: () => Navigator.of(context).pop(),
                ),
                _CenterPlayButton(
                  playing: _controller.value.isPlaying,
                  onTap: _togglePlay,
                ),
                _PlayerBottomBar(
                  controller: _controller,
                  isFullscreen: false,
                  pipAvailable: _pipAvailable,
                  speed: _speed,
                  onPlayPause: _togglePlay,
                  onSpeedTap: _showSpeedMenu,
                  onFullscreenToggle: _toggleFullscreen,
                  onPip: _enterPiP,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FullscreenOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final String movieName;
  final String episode;
  final bool pipAvailable;
  final ValueListenable<double> speed;
  final VoidCallback? onPip;
  final VoidCallback onSpeedTap;
  final VoidCallback onExit;

  const _FullscreenOverlay({
    required this.controller,
    required this.movieName,
    required this.episode,
    required this.pipAvailable,
    required this.speed,
    required this.onPip,
    required this.onSpeedTap,
    required this.onExit,
  });

  @override
  State<_FullscreenOverlay> createState() => _FullscreenOverlayState();
}

class _FullscreenOverlayState extends State<_FullscreenOverlay> {
  bool _controlsVisible = true;
  bool _rotationLocked = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onUpdate);
    _startHideTimer();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onUpdate);
    _hideTimer?.cancel();
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    if (widget.controller.value.isPlaying) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _controlsVisible = false);
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    if (_controlsVisible) _startHideTimer();
  }

  void _togglePlay() {
    final c = widget.controller;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
      _startHideTimer();
    }
  }

  void _toggleRotationLock() {
    setState(() {
      _rotationLocked = !_rotationLocked;
    });
    if (_rotationLocked) {
      final mq = MediaQuery.of(context);
      final notchLeft = mq.viewPadding.left > mq.viewPadding.right;
      SystemChrome.setPreferredOrientations([
        notchLeft
            ? DeviceOrientation.landscapeLeft
            : DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            if (_controlsVisible) ...[
              _PlayerTopBar(
                movieName: widget.movieName,
                episode: widget.episode,
                addSystemTopInset: true,
                onBack: widget.onExit,
              ),
              _CenterPlayButton(
                playing: widget.controller.value.isPlaying,
                onTap: _togglePlay,
              ),
              _PlayerBottomBar(
                controller: widget.controller,
                isFullscreen: true,
                pipAvailable: widget.pipAvailable,
                speed: widget.speed,
                rotationLocked: _rotationLocked,
                onPlayPause: _togglePlay,
                onSpeedTap: widget.onSpeedTap,
                onRotationLockToggle: _toggleRotationLock,
                onFullscreenToggle: widget.onExit,
                onPip: widget.onPip,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayerTopBar extends StatelessWidget {
  final String movieName;
  final String episode;
  final VoidCallback onBack;
  final bool addSystemTopInset;

  const _PlayerTopBar({
    required this.movieName,
    required this.episode,
    required this.onBack,
    this.addSystemTopInset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: (addSystemTopInset ? MediaQuery.of(context).padding.top : 0) + 8,
          left: 8,
          right: 8,
          bottom: 16,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movieName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    episode,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterPlayButton extends StatelessWidget {
  final bool playing;
  final VoidCallback onTap;

  const _CenterPlayButton({required this.playing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
            border: Border.all(color: Colors.white24),
          ),
          child: Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ),
    );
  }
}

class _PlayerBottomBar extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isFullscreen;
  final bool pipAvailable;
  final ValueListenable<double> speed;
  final VoidCallback onPlayPause;
  final VoidCallback onSpeedTap;
  final VoidCallback onFullscreenToggle;
  final bool? rotationLocked;
  final VoidCallback? onRotationLockToggle;
  final VoidCallback? onPip;

  const _PlayerBottomBar({
    required this.controller,
    required this.isFullscreen,
    required this.pipAvailable,
    required this.speed,
    required this.onPlayPause,
    required this.onSpeedTap,
    required this.onFullscreenToggle,
    this.rotationLocked,
    this.onRotationLockToggle,
    this.onPip,
  });

  String _formatDuration(Duration d) {
    return '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    final isPlaying = value.isPlaying;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom + 4,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              colors: const VideoProgressColors(
                playedColor: AppColors.gradientStart,
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white10,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: onPlayPause,
                ),
                Text(
                  '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                ValueListenableBuilder<double>(
                  valueListenable: speed,
                  builder: (context, s, _) => TextButton(
                    onPressed: onSpeedTap,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      '${s}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (rotationLocked != null && onRotationLockToggle != null)
                  IconButton(
                    icon: Icon(
                      rotationLocked!
                          ? Icons.screen_lock_rotation
                          : Icons.screen_rotation,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: rotationLocked! ? 'Mở khóa xoay' : 'Khóa xoay',
                    onPressed: onRotationLockToggle,
                  ),
                if (pipAvailable && onPip != null)
                  IconButton(
                    icon: const Icon(
                      Icons.picture_in_picture_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: 'Thu nhỏ',
                    onPressed: onPip,
                  ),
                IconButton(
                  icon: Icon(
                    isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: onFullscreenToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

