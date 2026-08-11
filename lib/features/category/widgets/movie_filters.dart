import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_panel.dart';
import '../../../shared/widgets/filter_dropdown.dart';
import '../../search/providers/search_provider.dart';

class MovieFilters extends ConsumerWidget {
  final String type;
  final String? subType;
  final String? status;
  final String? year;
  final String? country;
  final String sortBy;
  final bool hasActiveFilters;
  final ValueChanged<String?> onSubTypeChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onCountryChanged;
  final VoidCallback onClear;
  final ValueChanged<String> onSortChanged;

  const MovieFilters({
    super.key,
    required this.type,
    required this.subType,
    required this.status,
    required this.year,
    required this.country,
    required this.sortBy,
    required this.hasActiveFilters,
    required this.onSubTypeChanged,
    required this.onStatusChanged,
    required this.onYearChanged,
    required this.onCountryChanged,
    required this.onClear,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsAsync = ref.watch(yearsProvider);
    final countriesAsync = ref.watch(countriesProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'Phim bộ',
              active: subType == 'series',
              onTap: () =>
                  onSubTypeChanged(subType == 'series' ? null : 'series'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Phim lẻ',
              active: subType == 'single',
              onTap: () =>
                  onSubTypeChanged(subType == 'single' ? null : 'single'),
            ),
            const SizedBox(width: 12),
            _FilterChip(
              label: 'Đang chiếu',
              active: status == 'ongoing',
              onTap: () =>
                  onStatusChanged(status == 'ongoing' ? null : 'ongoing'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Hoàn thành',
              active: status == 'completed',
              onTap: () =>
                  onStatusChanged(status == 'completed' ? null : 'completed'),
            ),
            if (type != 'nam') ...[
              const SizedBox(width: 12),
              FilterDropdownButton(
                label: year ?? 'Năm',
                active: year != null,
                onTap: () async {
                  final value = await showFilterPicker(
                    context,
                    title: 'Chọn năm',
                    selected: year,
                    items: yearsAsync.when(
                      data: (items) =>
                          [for (final y in items) (label: y, value: y)],
                      loading: () => const [],
                      error: (_, _) => const [],
                    ),
                  );
                  if (value != null) onYearChanged(value);
                },
              ),
            ],
            if (type == 'the-loai') ...[
              const SizedBox(width: 8),
              FilterDropdownButton(
                label: country ?? 'Quốc gia',
                active: country != null,
                onTap: () async {
                  final value = await showFilterPicker(
                    context,
                    title: 'Chọn quốc gia',
                    selected: country,
                    items: countriesAsync.when(
                      data: (items) => [
                        for (final c in items)
                          (label: c.name, value: c.slug),
                      ],
                      loading: () => const [],
                      error: (_, _) => const [],
                    ),
                  );
                  if (value != null) onCountryChanged(value);
                },
              ),
            ],
            if (hasActiveFilters) ...[
              const SizedBox(width: 8),
              _FilterChip(label: 'Xoá', active: false, onTap: onClear),
            ],
            const SizedBox(width: 12),
            _SortChip(
              label: 'Mới nhất',
              active: sortBy == 'newest',
              onTap: () => onSortChanged('newest'),
            ),
            const SizedBox(width: 6),
            _SortChip(
              label: 'Năm giảm dần',
              active: sortBy == 'year',
              onTap: () => onSortChanged('year'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: active
            ? paginationActiveDecoration(radius: 20)
            : glassTileDecoration(radius: 20),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: active
            ? paginationActiveDecoration(radius: 20)
            : glassTileDecoration(radius: 20),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
