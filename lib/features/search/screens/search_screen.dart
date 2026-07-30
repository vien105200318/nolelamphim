import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/search_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/filter_chips.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import '../../home/widgets/movie_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCountry;
  String? _selectedYear;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String? slug) {
    setState(() => _selectedCategory = slug);
  }

  void _onCountrySelected(String? slug) {
    setState(() => _selectedCountry = slug);
  }

  void _onYearSelected(String? year) {
    setState(() => _selectedYear = year);
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: SearchBarWidget(
          controller: _searchController,
          onChanged: (value) =>
              ref.read(searchQueryProvider.notifier).state = value,
        ),
      ),
      body: Column(
        children: [
          FilterChips(
            selectedCategory: _selectedCategory,
            selectedCountry: _selectedCountry,
            selectedYear: _selectedYear,
            onCategorySelected: _onCategorySelected,
            onCountrySelected: _onCountrySelected,
            onYearSelected: _onYearSelected,
          ),
          Expanded(
            child: query.trim().isEmpty
                ? _buildEmpty()
                : resultsAsync.when(
                    data: (movies) => _buildResults(movies, ref),
                    loading: () => const _SearchLoadingGrid(),
                    error: (_, _) => _buildError(ref),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(
            'Tìm kiếm phim yêu thích',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhập tên phim để bắt đầu tìm kiếm',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<Movie> movies, WidgetRef ref) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(searchResultsProvider);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) => MovieCard(movie: movies[index]),
          );
        },
      ),
    );
  }

  Widget _buildError(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            'Có lỗi xảy ra',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => ref.invalidate(searchResultsProvider),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _SearchLoadingGrid extends StatelessWidget {
  const _SearchLoadingGrid();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 6,
            itemBuilder: (_, _) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }
}
