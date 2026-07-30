import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/movie.dart';
import '../providers/favorites_provider.dart';

class FavoriteButton extends ConsumerWidget {
  final Movie movie;
  final double iconSize;

  const FavoriteButton({super.key, required this.movie, this.iconSize = 24});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider.select((list) => list.any((m) => m.id == movie.id)));
    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.white70,
        size: iconSize,
      ),
      onPressed: () => ref.read(favoritesProvider.notifier).toggle(movie),
    );
  }
}
