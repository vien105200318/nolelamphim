import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../search/providers/search_provider.dart';
import '../../category/providers/category_provider.dart';
import '../widgets/tv_movie_card.dart';

class TvCategoryScreen extends ConsumerStatefulWidget {
  const TvCategoryScreen({super.key});

  @override
  ConsumerState<TvCategoryScreen> createState() => _TvCategoryScreenState();
}

class _TvCategoryScreenState extends ConsumerState<TvCategoryScreen> {
  String? _selectedCategory;
  String? _selectedCountry;
  String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final countriesAsync = ref.watch(countriesProvider);
    final yearsAsync = ref.watch(yearsProvider);

    final selectedSlug = _selectedCategory ?? _selectedCountry ?? _selectedYear;
    final isCategory = _selectedCategory != null;
    final isCountry = _selectedCountry != null;
    final isYear = _selectedYear != null;

    final moviesAsync = isCategory
        ? ref.watch(categoryMoviesProvider(selectedSlug!))
        : isCountry
            ? ref.watch(countryMoviesProvider(selectedSlug!))
            : isYear
                ? ref.watch(yearMoviesProvider(selectedSlug!))
                : null;

    return Container(
      color: AppColors.bgDark,
      child: RawScrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Danh mục',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Duyệt phim theo thể loại, quốc gia, năm',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              categoriesAsync.when(
                data: (cats) => _CategorySection(
                  title: 'Thể loại',
                  categories: cats,
                  selected: _selectedCategory,
                  onSelect: (slug) => setState(() {
                    _selectedCategory = slug;
                    _selectedCountry = null;
                    _selectedYear = null;
                  }),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              countriesAsync.when(
                data: (countries) => _CategorySection(
                  title: 'Quốc gia',
                  categories: countries,
                  selected: _selectedCountry,
                  onSelect: (slug) => setState(() {
                    _selectedCountry = slug;
                    _selectedCategory = null;
                    _selectedYear = null;
                  }),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              yearsAsync.when(
                data: (years) => _YearSection(
                  years: years,
                  selected: _selectedYear,
                  onSelect: (year) => setState(() {
                    _selectedYear = year;
                    _selectedCategory = null;
                    _selectedCountry = null;
                  }),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),
              if (moviesAsync != null)
                moviesAsync.when(
                  data: (movies) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kết quả',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: movies.map((m) => TvMovieCard(movie: m, width: 220, height: 330)).toList(),
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gradientMid)),
                  error: (_, _) => const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<dynamic> categories;
  final String? selected;
  final void Function(String slug) onSelect;

  const _CategorySection({
    required this.title,
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final item = categories[i];
              final slug = item.slug as String;
              final name = item.name as String;
              final isSelected = selected == slug;

              return Focus(
                child: Builder(builder: (ctx) {
                  final focused = Focus.of(ctx).hasFocus;
                  return GestureDetector(
                    onTap: () => onSelect(slug),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: focused
                            ? AppColors.gradientMid.withValues(alpha: 0.3)
                            : isSelected
                                ? AppColors.gradientMid.withValues(alpha: 0.2)
                                : AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(24),
                        border: focused
                            ? Border.all(color: AppColors.gradientMid, width: 2)
                            : isSelected
                                ? Border.all(color: AppColors.gradientMid.withValues(alpha: 0.5), width: 1.5)
                                : Border.all(color: Colors.transparent),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: focused ? Colors.white : AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: focused || isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _YearSection extends StatelessWidget {
  final List<String> years;
  final String? selected;
  final void Function(String year) onSelect;

  const _YearSection({
    required this.years,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Năm',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: years.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final isSelected = selected == years[i];
              return Focus(
                child: Builder(builder: (ctx) {
                  final focused = Focus.of(ctx).hasFocus;
                  return GestureDetector(
                    onTap: () => onSelect(years[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: focused
                            ? AppColors.gradientMid.withValues(alpha: 0.3)
                            : isSelected
                                ? AppColors.gradientMid.withValues(alpha: 0.2)
                                : AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(24),
                        border: focused
                            ? Border.all(color: AppColors.gradientMid, width: 2)
                            : isSelected
                                ? Border.all(color: AppColors.gradientMid.withValues(alpha: 0.5), width: 1.5)
                                : Border.all(color: Colors.transparent),
                      ),
                      child: Text(
                        years[i],
                        style: TextStyle(
                          color: focused ? Colors.white : AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: focused || isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
