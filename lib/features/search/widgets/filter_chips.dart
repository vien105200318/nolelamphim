import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../../../core/theme/app_colors.dart';

class FilterChips extends ConsumerWidget {
  final String? selectedCategory;
  final String? selectedCountry;
  final String? selectedYear;
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<String?> onCountrySelected;
  final ValueChanged<String?> onYearSelected;

  const FilterChips({
    super.key,
    this.selectedCategory,
    this.selectedCountry,
    this.selectedYear,
    required this.onCategorySelected,
    required this.onCountrySelected,
    required this.onYearSelected,
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
            _FilterDropdown(
              label: selectedCategory ?? 'Thể loại',
              active: selectedCategory != null,
              onTap: () => _showPicker(
                context,
                'Chọn thể loại',
                categoriesAsync.when(
                  data: (items) =>
                      items.map((e) => _PickerItem(e.name, e.slug)).toList(),
                  loading: () => [],
                  error: (_, _) => [],
                ),
                onCategorySelected,
              ),
            ),
            const SizedBox(width: 8),
            _FilterDropdown(
              label: selectedCountry ?? 'Quốc gia',
              active: selectedCountry != null,
              onTap: () => _showPicker(
                context,
                'Chọn quốc gia',
                countriesAsync.when(
                  data: (items) =>
                      items.map((e) => _PickerItem(e.name, e.slug)).toList(),
                  loading: () => [],
                  error: (_, _) => [],
                ),
                onCountrySelected,
              ),
            ),
            const SizedBox(width: 8),
            _FilterDropdown(
              label: selectedYear ?? 'Năm',
              active: selectedYear != null,
              onTap: () => _showPicker(
                context,
                'Chọn năm',
                yearsAsync.when(
                  data: (items) =>
                      items.map((e) => _PickerItem(e, e)).toList(),
                  loading: () => [],
                  error: (_, _) => [],
                ),
                onYearSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(
    BuildContext context,
    String title,
    List<_PickerItem> items,
    ValueChanged<String?> onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: AppColors.bgCard, height: 1),
            SizedBox(
              height: 300,
              child: items.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary))
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const Divider(color: AppColors.bgCard, height: 1),
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return ListTile(
                          title: Text(
                            item.label,
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
                          onTap: () {
                            onSelected(item.value);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _PickerItem {
  final String label;
  final String value;
  _PickerItem(this.label, this.value);
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterDropdown({
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
          color: active ? AppColors.primary : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: active ? Colors.white : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
