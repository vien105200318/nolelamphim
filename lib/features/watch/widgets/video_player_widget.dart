import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../core/pip/pip_service.dart';
import '../../../core/theme/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String movieName;
  final String episode;

  const VideoPlayerWidget({
    super.key,
    required this.url,
    required this.movieName,
    required this.episode,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeFuture;
  bool _controlsVisible = true;
  Timer? _hideTimer;
  bool _isFullscreen = false;
  OverlayEntry? _fullscreenEntry;
  bool _pipAvailable = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initializeFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.addListener(_onControllerUpdate);
    _startHideTimer();
    _initPiP();
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

  @override
  void dispose() {
    _fullscreenEntry?.remove();
    _fullscreenEntry = null;
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _hideTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
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
        onPip: _enterPiP,
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
                  onPlayPause: _togglePlay,
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
  final VoidCallback? onPip;
  final VoidCallback onExit;

  const _FullscreenOverlay({
    required this.controller,
    required this.movieName,
    required this.episode,
    required this.pipAvailable,
    required this.onPip,
    required this.onExit,
  });

  @override
  State<_FullscreenOverlay> createState() => _FullscreenOverlayState();
}

class _FullscreenOverlayState extends State<_FullscreenOverlay> {
  bool _controlsVisible = true;
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
                onPlayPause: _togglePlay,
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

  const _PlayerTopBar({
    required this.movieName,
    required this.episode,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
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
  final VoidCallback onPlayPause;
  final VoidCallback onFullscreenToggle;
  final VoidCallback? onPip;

  const _PlayerBottomBar({
    required this.controller,
    required this.isFullscreen,
    required this.pipAvailable,
    required this.onPlayPause,
    required this.onFullscreenToggle,
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

