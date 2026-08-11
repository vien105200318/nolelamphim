import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Mở modal kính bottom-sheet theo phong cách glass (spec §4.12, §4.13).
/// `items` là danh sách lựa chọn; mục đầu tiên active mặc định = gradient + border tím.
Future<T?> showGlassModal<T>({
  required BuildContext context,
  required String title,
  required List<GlassModalItem<T>> items,
  T? initial,
  String? subtitle,
  Widget? extra,
  Widget? footer,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (ctx) => _GlassModal<T>(
      title: title,
      subtitle: subtitle,
      items: items,
      initial: initial,
      extra: extra,
      footer: footer,
    ),
  );
}

class GlassModalItem<T> {
  final String label;
  final T value;
  final Widget? leading;

  const GlassModalItem({required this.label, required this.value, this.leading});
}

class _GlassModal<T> extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<GlassModalItem<T>> items;
  final T? initial;
  final Widget? extra;
  final Widget? footer;

  const _GlassModal({
    required this.title,
    required this.items,
    this.subtitle,
    this.initial,
    this.extra,
    this.footer,
  });

  @override
  State<_GlassModal<T>> createState() => _GlassModalState<T>();
}

class _GlassModalState<T> extends State<_GlassModal<T>> {
  late T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial ?? (widget.items.isNotEmpty ? widget.items.first.value : null);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x17FFFFFF), Color(0x08FFFFFF)],
          ),
          color: AppColors.glassBackdrop,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.extra != null) widget.extra!,
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: widget.items.length,
                separatorBuilder: (_, _) =>
                    const Divider(color: Color(0x0DFFFFFF), height: 1),
                itemBuilder: (_, i) {
                  final item = widget.items[i];
                  final active = _selected == item.value;
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      side: active
                          ? BorderSide(
                              color: AppColors.gradientMid
                                  .withValues(alpha: 0.35),
                            )
                          : BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: item.leading,
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: active
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: active
                        ? const Icon(Icons.check_circle,
                            color: AppColors.emerald, size: 20)
                        : null,
                    tileColor: active
                        ? AppColors.gradientMid.withValues(alpha: 0.12)
                        : null,
                    onTap: () {
                      Navigator.of(context).pop(item.value);
                    },
                  );
                },
              ),
            ),
            if (widget.footer != null) widget.footer!,
          ],
        ),
      ),
    );
  }
}
