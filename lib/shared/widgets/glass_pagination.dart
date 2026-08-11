import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'glass_panel.dart';

/// Pagination glass — spec §4.8: `« ‹ [trang] › »`, trang active = gradient
/// accent, còn lại glass-tile, disabled ở trang đầu/cuối (mờ 30%).
class GlassPagination extends StatelessWidget {
  final int page;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const GlassPagination({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<int> get _pages {
    if (totalPages <= 5) {
      return List.generate(totalPages, (i) => i + 1);
    }
    if (page <= 3) return [1, 2, 3, 4, 5];
    if (page >= totalPages - 2) {
      return List.generate(5, (i) => totalPages - 4 + i);
    }
    return [page - 2, page - 1, page, page + 1, page + 2];
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PageButton(
            icon: Icons.first_page,
            enabled: page > 1,
            onTap: () => onPageChanged(1),
          ),
          _PageButton(
            icon: Icons.chevron_left,
            enabled: page > 1,
            onTap: () => onPageChanged(page - 1),
          ),
          for (final p in _pages) _PageNumber(p: p, page: page, onTap: onPageChanged),
          _PageButton(
            icon: Icons.chevron_right,
            enabled: page < totalPages,
            onTap: () => onPageChanged(page + 1),
          ),
          _PageButton(
            icon: Icons.last_page,
            enabled: page < totalPages,
            onTap: () => onPageChanged(totalPages),
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.3,
      child: GlassTile(
        radius: 10,
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        onTap: enabled ? onTap : null,
        child: Icon(icon, size: 16, color: AppColors.textSecondary),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  final int p;
  final int page;
  final ValueChanged<int> onTap;

  const _PageNumber({
    required this.p,
    required this.page,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = p == page;
    return GestureDetector(
      onTap: () => onTap(p),
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: active ? paginationActiveDecoration(radius: 10) : glassTileDecoration(radius: 10),
        child: Text(
          '$p',
          style: TextStyle(
            color: active ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
