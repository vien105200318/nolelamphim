import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';

class TvLoadingGrid extends StatelessWidget {
  const TvLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Container(
              width: 200,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 6,
              itemBuilder: (_, _) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TvHeroLoading extends StatelessWidget {
  const TvHeroLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: Container(
        height: 400,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class TvErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const TvErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 20),
          const Text(
            'Không thể tải dữ liệu',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 20),
          ),
          const SizedBox(height: 20),
          Focus(
            child: Builder(builder: (ctx) {
              final focused = Focus.of(ctx).hasFocus;
              return GestureDetector(
                onTap: onRetry,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: focused
                        ? const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd])
                        : LinearGradient(
                            colors: [AppColors.gradientStart.withValues(alpha: 0.5), AppColors.gradientMid.withValues(alpha: 0.5)],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: focused ? Border.all(color: AppColors.gradientMid, width: 2) : null,
                  ),
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
