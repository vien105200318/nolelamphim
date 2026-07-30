import 'package:flutter/services.dart';

typedef PiPExitCallback = void Function();

class PiPService {
  static const _channel = MethodChannel('com.example.nolelamphim/pip');
  static PiPExitCallback? _onExit;

  static void _setupListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPiPExit') {
        _onExit?.call();
      }
    });
  }

  static Future<bool> get isAvailable async {
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> enterPiP({
    int preferredWidth = 320,
    int preferredHeight = 180,
    String? videoUrl,
    double startSeconds = 0,
    PiPExitCallback? onExit,
  }) async {
    _onExit = onExit;
    _setupListener();
    try {
      final args = <String, dynamic>{
        'preferredWidth': preferredWidth,
        'preferredHeight': preferredHeight,
      };
      if (videoUrl != null) {
        args['url'] = videoUrl;
        args['startSeconds'] = startSeconds;
      }
      return await _channel.invokeMethod<bool>('enterPiP', args) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> exitPiP() async {
    try {
      await _channel.invokeMethod<void>('exitPiP');
    } catch (_) {}
  }

  static Future<bool> get isInPiP async {
    try {
      return await _channel.invokeMethod<bool>('isInPiP') ?? false;
    } catch (_) {
      return false;
    }
  }
}
