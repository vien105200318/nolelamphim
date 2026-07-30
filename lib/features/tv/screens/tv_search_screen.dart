import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import '../../search/providers/search_provider.dart';
import '../widgets/tv_movie_card.dart';

class TvSearchScreen extends ConsumerStatefulWidget {
  const TvSearchScreen({super.key});

  @override
  ConsumerState<TvSearchScreen> createState() => _TvSearchScreenState();
}

class _TvSearchScreenState extends ConsumerState<TvSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final countriesAsync = ref.watch(countriesProvider);
    final yearsAsync = ref.watch(yearsProvider);

    return Container(
      color: AppColors.bgDark,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child: Focus(
              child: Builder(builder: (ctx) {
                final focused = Focus.of(ctx).hasFocus;
                return Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: focused
                        ? AppColors.glassWhite.withValues(alpha: 0.15)
                        : AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: focused
                        ? Border.all(color: AppColors.gradientMid, width: 2)
                        : Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Icon(
                        Icons.search,
                        color: focused ? AppColors.gradientStart : AppColors.textMuted,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Tìm kiếm phim...',
                            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 20),
                            border: InputBorder.none,
                          ),
                          onChanged: (v) {
                            ref.read(searchQueryProvider.notifier).state = v;
                          },
                        ),
                      ),
                      if (query.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textMuted),
                          onPressed: () {
                            _controller.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                            _focusNode.requestFocus();
                          },
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _showFilters = !_showFilters),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.glassWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune,
                                size: 22,
                                color: _showFilters ? AppColors.gradientStart : AppColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Bộ lọc',
                                style: TextStyle(
                                  color: _showFilters ? AppColors.gradientStart : AppColors.textMuted,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                );
              }),
            ),
          ),
          if (_showFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  categoriesAsync.when(
                    data: (cats) => _FilterRow(title: 'Thể loại', items: cats.map((c) => c.name).toList()),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 12),
                  yearsAsync.when(
                    data: (years) => _FilterRow(title: 'Năm', items: years),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 12),
                  countriesAsync.when(
                    data: (countries) => _FilterRow(title: 'Quốc gia', items: countries.map((c) => c.name).toList()),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: query.trim().isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, size: 80, color: AppColors.textMuted),
                        const SizedBox(height: 20),
                        const Text(
                          'Nhập tên phim để tìm kiếm',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : resultsAsync.when(
                    data: (movies) => _buildResults(movies),
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gradientMid)),
                    error: (_, _) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => ref.invalidate(searchResultsProvider),
                            child: const Text('Thử lại', style: TextStyle(color: AppColors.gradientStart, fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie_outlined, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            const Text(
              'Không tìm thấy kết quả',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 20),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: movies.map((m) => TvMovieCard(movie: m, width: 220, height: 330)).toList(),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FilterRow({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.take(20).length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => Focus(
              child: Builder(builder: (ctx) {
                final focused = Focus.of(ctx).hasFocus;
                return GestureDetector(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: focused ? AppColors.gradientMid.withValues(alpha: 0.3) : AppColors.glassWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: focused ? Border.all(color: AppColors.gradientMid, width: 2) : Border.all(color: Colors.transparent, width: 2),
                    ),
                    child: Text(
                      items[i],
                      style: TextStyle(
                        color: focused ? AppColors.textPrimary : AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
