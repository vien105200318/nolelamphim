import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Skeleton tĩnh (spec §4.4 — mobile dùng nền tĩnh thay vì shimmer animation).
class CardSkeleton extends StatelessWidget {
  final double? width;
  final double? height;

  const CardSkeleton({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x0DFFFFFF), Color(0x03FFFFFF)],
              ),
              color: AppColors.bgCard,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 72,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.bgCard.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

/// Lưới skeleton dùng trong khi load danh sách phim.
class GridSkeleton extends StatelessWidget {
  final int columns;
  final int count;

  const GridSkeleton({super.key, this.columns = 2, this.count = 10});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 10 * (columns - 1)) / columns;
        final itemHeight = itemWidth / 0.6;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 0.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
          ),
          itemCount: count,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, _) => CardSkeleton(width: itemWidth, height: itemHeight),
        );
      },
    );
  }
}

/// Skeleton khối ngang (hero + section list).
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.28;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: h,
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.bgCard,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 20,
            width: 140,
            margin: const EdgeInsets.only(left: 16, bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 5,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, _) => const SizedBox(
                width: 140,
                child: CardSkeleton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
