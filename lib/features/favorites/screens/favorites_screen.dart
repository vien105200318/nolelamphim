import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../home/widgets/movie_card.dart';
import '../providers/favorites_provider.dart';

/// Yêu thích — spec §5.8: h1 "Phim yêu thích", empty + "Khám phá phim",
/// lưới card 2-8 cột.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: const Text('Phim yêu thích'),
      ),
      body: list.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: EmptyState(
                icon: Icons.favorite_border,
                title: 'Chưa có phim yêu thích',
                subtitle: 'Bấm ♡ trên trang phim để lưu vào đây',
                actionLabel: 'Khám phá phim',
                onAction: () => context.go('/'),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.58,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: list.length,
                  itemBuilder: (_, i) => MovieCard(movie: list[i]),
                );
              },
            ),
    );
  }
}
