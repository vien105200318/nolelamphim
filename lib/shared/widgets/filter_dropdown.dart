import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FilterDropdownButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const FilterDropdownButton({
    super.key,
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

typedef FilterPickerItem = ({String label, String value});

Future<String?> showFilterPicker(
  BuildContext context, {
  required String title,
  required List<FilterPickerItem> items,
  String? selected,
  bool isLoading = false,
}) {
  return showModalBottomSheet<String>(
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
            height: 320,
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary))
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: AppColors.bgCard, height: 1),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final isSelected = item.value == selected;
                      return ListTile(
                        leading: isSelected
                            ? const Icon(
                                Icons.check,
                                color: AppColors.primary,
                                size: 20,
                              )
                            : null,
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        onTap: () => Navigator.pop(ctx, item.value),
                      );
                    },
                  ),
          ),
        ],
      );
    },
  );
}
