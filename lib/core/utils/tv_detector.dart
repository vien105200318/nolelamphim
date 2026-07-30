import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvModeProvider = StateProvider<bool>((ref) => false);

bool isTv(BuildContext context, WidgetRef ref) {
  if (ref.watch(tvModeProvider)) return true;
  final size = MediaQuery.of(context).size;
  final shortest = size.shortestSide;
  if (shortest < 600) return false;
  final aspectRatio = size.width / size.height;
  return aspectRatio > 1.3;
}
