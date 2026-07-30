import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TvDetector {
  static bool isTv([BuildContext? context]) {
    ui.Display? display;

    if (context != null) {
      final size = MediaQuery.of(context).size;
      final shortest = size.shortestSide;
      if (shortest < 450) return false;
      final aspectRatio = size.width / size.height;
      return aspectRatio > 1.3;
    }

    display = ui.PlatformDispatcher.instance.displays.firstOrNull;
    if (display == null) return false;
    final size = display.size;
    final shortest = size.shortestSide;
    if (shortest < 450) return false;
    final aspectRatio = size.width / size.height;
    return aspectRatio > 1.3;
  }
}
