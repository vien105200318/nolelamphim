import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/search_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_filters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import '../../../shared/widgets/glass_pagination.dart';
import '../../home/providers/home_provider.dart';
import '../../home/widgets/movie_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String? _sortBy;
  bool _queryApplied = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialQuery;
    if (initial != null && initial.trim().isNotEmpty) {
      _searchController.text = initial;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final initial = widget.initialQuery;
    if (!_queryApplied && initial != null && initial.trim().isNotEmpty) {
      _queryApplied = true;
      ref.read(searchQueryProvider.notifier).state = initial.trim();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    ref.read(searchPageProvider.notifier).state = 1;
    ref.read(searchQueryProvider.notifier).state = value;
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      ref.read(recentSearchesProvider.notifier).add(value);
    }
  }

  void _onFilterSelected(SearchFilter filter) {
    ref.read(searchFilterProvider.notifier).state = filter;
    ref.read(searchQueryProvider.notifier).state = '';
    _searchController.clear();
    ref.read(searchPageProvider.notifier).state = 1;
  }

  void _onClearFilter() {
    ref.read(searchFilterProvider.notifier).state = null;
    ref.read(searchPageProvider.notifier).state = 1;
  }

  void _onRecentTap(String query) {
    _searchController.text = query;
    ref.read(searchQueryProvider.notifier).state = query;
    ref.read(searchPageProvider.notifier).state = 1;
    ref.read(recentSearchesProvider.notifier).add(query);
  }

  void _onPageChanged(int page) {
    ref.read(searchPageProvider.notifier).state = page;
  }

  List<Movie> _sorted(List<Movie> movies) {
    final copy = List<Movie>.from(movies);
    if (_sortBy == 'name') {
      copy.sort((a, b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_sortBy == 'year') {
      copy.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
    }
    return copy;
  }

  String _resultLabel(String query, SearchFilter? filter) {
    if (filter != null) {
      return switch (filter.type) {
        'category' => 'Thể loại: ${filter.label}',
        'country' => 'Quốc gia: ${filter.label}',
        _ => 'Năm: ${filter.label}',
      };
    }
    return 'Kết quả cho "$query"';
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final filter = ref.watch(searchFilterProvider);
    final pagedAsync = ref.watch(searchPagedProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final suggestionsAsync = ref.watch(searchSuggestionsProvider);

    final isSearching = query.trim().isNotEmpty || filter != null;
    final showSort = pagedAsync.valueOrNull?.items.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: SearchBarWidget(
          controller: _searchController,
          onChanged: _onQueryChanged,
          onSubmitted: _onSubmitted,
        ),
      ),
      body: Column(
        children: [
          SearchFilters(
            filter: filter,
            sortBy: _sortBy,
            showSort: showSort,
            onFilterSelected: _onFilterSelected,
            onClearFilter: _onClearFilter,
            onSortChanged: (value) => setState(() => _sortBy = value),
          ),
          Expanded(
            child: isSearching
                ? _buildSearchingBody(query, filter, pagedAsync, suggestionsAsync)
                : _buildIdle(recentSearches),
          ),
        ],
      ),
    );
  }

  Widget _buildIdle(List<String> recentSearches) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gần đây',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      ref.read(recentSearchesProvider.notifier).clear(),
                  child: const Text(
                    'Xoá',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in recentSearches)
                  GestureDetector(
                    onTap: () => _onRecentTap(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.history,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            item,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              const Icon(Icons.search,
                  size: 64, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text(
                'Tìm kiếm phim yêu thích',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Nhập tên phim để bắt đầu tìm kiếm',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchingBody(
    String query,
    SearchFilter? filter,
    AsyncValue<PagedMovies> pagedAsync,
    AsyncValue<List<Movie>> suggestionsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Text(
            _resultLabel(query, filter),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ),
        _buildSuggestions(suggestionsAsync),
        const SizedBox(height: 8),
        Expanded(
          child: pagedAsync.when(
            data: (paged) => _buildResults(_sorted(paged.items), paged.totalPages),
            loading: () => const _SearchLoadingGrid(),
            error: (_, _) => _buildError(),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(AsyncValue<List<Movie>> suggestionsAsync) {
    return suggestionsAsync.maybeWhen(
      data: (movies) {
        if (movies.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              for (var i = 0; i < movies.length; i++) ...[
                if (i > 0)
                  const Divider(
                    color: AppColors.bgCard,
                    height: 1,
                    indent: 12,
                    endIndent: 12,
                  ),
                _SuggestionTile(movie: movies[i]),
              ],
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildResults(List<Movie> movies, int totalPages) {
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

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(searchPagedProvider);
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.58,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) =>
                      MovieCard(movie: movies[index]),
                );
              },
            ),
          ),
        ),
        GlassPagination(
          page: ref.watch(searchPageProvider),
          totalPages: totalPages,
          onPageChanged: _onPageChanged,
        ),
      ],
    );
  }

  Widget _buildError() {
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
            onPressed: () => ref.invalidate(searchPagedProvider),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final Movie movie;

  const _SuggestionTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/phim/${movie.slug}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                movie.posterUrl ?? movie.thumbUrl ?? '',
                width: 40,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 40,
                  height: 56,
                  color: AppColors.bgCard,
                  child: const Icon(Icons.movie, size: 18, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (movie.year != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${movie.year}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward,
                size: 16, color: AppColors.textMuted),
          ],
        ),
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
              childAspectRatio: 0.58,
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
