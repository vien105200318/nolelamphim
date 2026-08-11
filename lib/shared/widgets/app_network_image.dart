import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Ảnh mạng tải TRỰC TIẾP bằng `Image.network` (không cache ổ đĩa).
///
/// Thay thế `CachedNetworkImage`: stack mặc định (flutter_cache_manager +
/// sqlite + http client nội bộ) bị treo khi tải ảnh trên một số thiết bị —
/// poster không hiện. `Image.network` dùng đúng HTTP stack của API
/// (dart:io) nên ổn định; ảnh chỉ được cache trong bộ nhớ.
class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext)? placeholder;
  final Widget Function(BuildContext)? error;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return error?.call(context) ?? _defaultError(context);
    }
    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder?.call(context) ?? _defaultLoading(context);
      },
      errorBuilder: (_, _, _) => error?.call(context) ?? _defaultError(context),
    );
  }

  Widget _defaultLoading(BuildContext context) =>
      Container(color: AppColors.bgCard);

  Widget _defaultError(BuildContext context) => Container(
        color: AppColors.bgCard,
        alignment: Alignment.center,
        child: const Icon(Icons.movie, color: AppColors.textMuted, size: 32),
      );
}
