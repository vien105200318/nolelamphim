import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/ratings_provider.dart';

/// RatingBox 5 sao — spec §5.3: sao vàng có glow khi active, lưu local
/// (key `ratings` = `{slug: điểm}`), nhãn "Đánh giá của bạn" / "Bạn: X/5".
class RatingBox extends ConsumerWidget {
  final String slug;
  final String? name;

  const RatingBox({super.key, required this.slug, this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(ratingsProvider.select((map) => map[slug] ?? 0));

    return Tooltip(
      message: value > 0
          ? 'Bạn đã đánh giá $value/5 (lưu trên máy này)'
          : 'Đánh giá phim này (lưu trên máy của bạn)',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) {
              final filled = i + 1 <= value;
              return GestureDetector(
                onTap: () =>
                    ref.read(ratingsProvider.notifier).rate(slug, i + 1),
                child: AnimatedScale(
                  scale: 1,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    child: Icon(
                      Icons.star_rounded,
                      size: 19,
                      color: filled
                          ? AppColors.accentGold
                          : AppColors.starEmpty,
                      shadows: filled
                          ? [
                              Shadow(
                                color: AppColors.accentGold
                                    .withValues(alpha: 0.5),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 2),
          Text(
            value > 0 ? 'Bạn: $value/5' : 'Đánh giá của bạn',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
