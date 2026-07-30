import 'package:flutter/material.dart';

class TvDetector {
  static bool isTv(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide;
    if (shortest < 600) return false;
    final aspectRatio = size.width / size.height;
    return aspectRatio > 1.3;
  }
}
