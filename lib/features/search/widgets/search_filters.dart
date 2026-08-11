import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/filter_dropdown.dart';
import '../providers/search_provider.dart';

class SearchFilters extends ConsumerWidget {
  final SearchFilter? filter;
  final String? sortBy;
  final bool showSort;
  final ValueChanged<SearchFilter> onFilterSelected;
  final VoidCallback onClearFilter;
  final ValueChanged<String?> onSortChanged;

  const SearchFilters({
    super.key,
    required this.filter,
    required this.sortBy,
    required this.showSort,
    required this.onFilterSelected,
    required this.onClearFilter,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final countriesAsync = ref.watch(countriesProvider);
    final yearsAsync = ref.watch(yearsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterDropdownButton(
              label: filter?.type == 'category' ? filter!.label : 'Thể loại',
              active: filter?.type == 'category',
              onTap: () async {
                final value = await showFilterPicker(
                  context,
                  title: 'Chọn thể loại',
                  selected: filter?.type == 'category' ? filter!.value : null,
                  items: categoriesAsync.when(
                    data: (items) => [
                      for (final c in items)
                        (label: c.name, value: c.slug),
                    ],
                    loading: () => const [],
                    error: (_, _) => const [],
                  ),
                );
                if (value != null) {
                  final label = categoriesAsync.when(
                    data: (items) => items
                        .where((c) => c.slug == value)
                        .map((c) => c.name)
                        .firstOrNull,
                    loading: () => null,
                    error: (_, _) => null,
                  );
                  onFilterSelected(
                    SearchFilter(
                      type: 'category',
                      label: label ?? value,
                      value: value,
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 8),
            FilterDropdownButton(
              label: filter?.type == 'country' ? filter!.label : 'Quốc gia',
              active: filter?.type == 'country',
              onTap: () async {
                final value = await showFilterPicker(
                  context,
                  title: 'Chọn quốc gia',
                  selected: filter?.type == 'country' ? filter!.value : null,
                  items: countriesAsync.when(
                    data: (items) => [
                      for (final c in items)
                        (label: c.name, value: c.slug),
                    ],
                    loading: () => const [],
                    error: (_, _) => const [],
                  ),
                );
                if (value != null) {
                  final label = countriesAsync.when(
                    data: (items) => items
                        .where((c) => c.slug == value)
                        .map((c) => c.name)
                        .firstOrNull,
                    loading: () => null,
                    error: (_, _) => null,
                  );
                  onFilterSelected(
                    SearchFilter(
                      type: 'country',
                      label: label ?? value,
                      value: value,
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 8),
            FilterDropdownButton(
              label: filter?.type == 'year' ? filter!.label : 'Năm',
              active: filter?.type == 'year',
              onTap: () async {
                final value = await showFilterPicker(
                  context,
                  title: 'Chọn năm',
                  selected: filter?.type == 'year' ? filter!.value : null,
                  items: yearsAsync.when(
                    data: (items) => [
                      for (final y in items) (label: y, value: y),
                    ],
                    loading: () => const [],
                    error: (_, _) => const [],
                  ),
                );
                if (value != null) {
                  onFilterSelected(
                    SearchFilter(type: 'year', label: value, value: value),
                  );
                }
              },
            ),
            if (filter != null) ...[
              const SizedBox(width: 8),
              _ClearFilterButton(onTap: onClearFilter),
            ],
            if (showSort) ...[
              const SizedBox(width: 12),
              _SortButton(
                label: 'Tên',
                active: sortBy == 'name',
                onTap: () => onSortChanged(sortBy == 'name' ? null : 'name'),
              ),
              const SizedBox(width: 6),
              _SortButton(
                label: 'Năm',
                active: sortBy == 'year',
                onTap: () => onSortChanged(sortBy == 'year' ? null : 'year'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClearFilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearFilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.close, size: 16, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text(
              'Xoá',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SortButton({
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
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.glassWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.glassBorder,
          ),
        ),
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
