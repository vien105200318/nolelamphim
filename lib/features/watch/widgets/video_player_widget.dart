import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initializeFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.addListener(_onControllerUpdate);
    _startHideTimer();
  }

  @override
  void dispose() {
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

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  String _formatDuration(Duration d) {
    return '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
                const Icon(Icons.error_outline, size: 48, color: Colors.white54),
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
                _buildTopOverlay(),
                _buildCenterPlayButton(),
                _buildBottomOverlay(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopOverlay() {
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
        decoration: BoxDecoration(
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.movieName,
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
                    widget.episode,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterPlayButton() {
    return Center(
      child: AnimatedOpacity(
        opacity: _controlsVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
              _startHideTimer();
            }
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
            ),
            child: Icon(
              _controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomOverlay() {
    final value = _controller.value;
    final duration = value.duration;
    final position = value.position;
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
        decoration: BoxDecoration(
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
              _controller,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              colors: const VideoProgressColors(
                playedColor: Color(0xFFFF6B9D),
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white10,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    isPlaying ? _controller.pause() : _controller.play();
                    _startHideTimer();
                  },
                ),
                Text(
                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isFullscreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: _toggleFullscreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}