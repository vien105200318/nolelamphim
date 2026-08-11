import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/movie.dart';
import '../../../shared/widgets/glass_pagination.dart';
import '../../home/widgets/movie_card.dart';
import '../providers/category_provider.dart';
import '../widgets/movie_filters.dart';

class CategoryMoviesScreen extends ConsumerStatefulWidget {
  final String type;
  final String slug;
  final String title;

  const CategoryMoviesScreen({
    super.key,
    required this.type,
    required this.slug,
    required this.title,
  });

  @override
  ConsumerState<CategoryMoviesScreen> createState() =>
      _CategoryMoviesScreenState();
}

class _CategoryMoviesScreenState extends ConsumerState<CategoryMoviesScreen> {
  String? _subType;
  String? _status;
  String? _year;
  String? _country;
  String _sortBy = 'newest';
  int _page = 1;

  CategoryQuery get _query => CategoryQuery(
        type: widget.type,
        slug: widget.slug,
        subType: _subType,
        status: _status,
        year: _year,
        country: _country,
        page: _page,
      );

  bool get _hasActiveFilters =>
      _subType != null || _status != null || _year != null || _country != null;

  void _onSubTypeChanged(String? value) {
    setState(() {
      _subType = value;
      _page = 1;
    });
  }

  void _onStatusChanged(String? value) {
    setState(() {
      _status = value;
      _page = 1;
    });
  }

  void _onYearChanged(String? value) {
    setState(() {
      _year = value;
      _page = 1;
    });
  }

  void _onCountryChanged(String? value) {
    setState(() {
      _country = value;
      _page = 1;
    });
  }

  void _onClear() {
    setState(() {
      _subType = null;
      _status = null;
      _year = null;
      _country = null;
      _page = 1;
    });
  }

  void _onSortChanged(String value) {
    setState(() => _sortBy = value);
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
  }

  List<Movie> _sorted(List<Movie> movies) {
    if (_sortBy != 'year') return movies;
    final copy = List<Movie>.from(movies);
    copy.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(categoryListProvider(_query));

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/category'),
        ),
      ),
      body: Column(
        children: [
          MovieFilters(
            type: widget.type,
            subType: _subType,
            status: _status,
            year: _year,
            country: _country,
            sortBy: _sortBy,
            hasActiveFilters: _hasActiveFilters,
            onSubTypeChanged: _onSubTypeChanged,
            onStatusChanged: _onStatusChanged,
            onYearChanged: _onYearChanged,
            onCountryChanged: _onCountryChanged,
            onClear: _onClear,
            onSortChanged: _onSortChanged,
          ),
          Expanded(
            child: moviesAsync.when(
              data: (paged) => _buildGrid(_sorted(paged.items), paged.totalPages),
              loading: () => const _MovieGridLoading(),
              error: (_, _) => _buildError(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Movie> movies, int totalPages) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'Không có phim nào',
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
              ref.invalidate(categoryListProvider(_query));
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
          page: _page,
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
          const Icon(Icons.error_outline, size: 48, color: AppColors.textMuted),
          const SizedBox(height: 12),
          const Text(
            'Có lỗi xảy ra',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => ref.invalidate(categoryListProvider(_query)),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _MovieGridLoading extends StatelessWidget {
  const _MovieGridLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgSurface,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
