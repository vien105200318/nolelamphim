import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/list_response.dart';
import '../../../core/models/movie.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final newMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.newMovies, params: {'page': 1});
  final data = ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  );
  return data.items;
});

final subteamProvider = FutureProvider<List<Movie>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.subteam, params: {'limit': 20});
  final data = ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  );
  return data.items;
});

// ============================================================
// Phim mới cập nhật — phân trang (grid cuối trang chủ)
// ============================================================

class PagedMovies {
  final List<Movie> items;
  final int totalPages;

  const PagedMovies({required this.items, required this.totalPages});
}

PagedMovies _parsePagedMovies(dynamic data) {
  final map = data as Map<String, dynamic>;
  final items = (map['items'] as List<dynamic>?)
          ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Movie>[];
  final pagination = map['pagination'] as Map<String, dynamic>?;
  final totalPages = (pagination?['totalPages'] as num?)?.toInt() ?? 1;
  return PagedMovies(items: items, totalPages: totalPages);
}

class NewMoviesGridState {
  final List<Movie> movies;
  final bool isLoading;
  final bool hasMore;
  final Object? error;

  const NewMoviesGridState({
    this.movies = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  NewMoviesGridState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    bool? hasMore,
    Object? error,
    bool clearError = false,
  }) {
    return NewMoviesGridState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class NewMoviesGridNotifier extends StateNotifier<NewMoviesGridState> {
  NewMoviesGridNotifier(this.ref) : super(const NewMoviesGridState());

  final Ref ref;
  int _page = 0;
  int _totalPages = 1;

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get(
        ApiEndpoints.newMovies,
        params: {'page': _page + 1},
      );
      final result = _parsePagedMovies(response.data);
      _page++;
      _totalPages = result.totalPages;
      state = state.copyWith(
        movies: [...state.movies, ...result.items],
        isLoading: false,
        hasMore: _page < _totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh() async {
    _page = 0;
    _totalPages = 1;
    state = const NewMoviesGridState(isLoading: true);
    await loadMore();
  }
}

final newMoviesGridProvider =
    StateNotifierProvider<NewMoviesGridNotifier, NewMoviesGridState>((ref) {
  return NewMoviesGridNotifier(ref)..loadMore();
});

// ============================================================
// Chủ đề (ThemeSection) — 7 thẻ tương ứng web `ThemeSection.astro`
// ============================================================

class ThemeConfig {
  final String label;
  final String sub;
  final List<Color> gradient;
  final String? categorySlug;
  final String? searchQuery;
  final bool isNew;

  const ThemeConfig({
    required this.label,
    required this.sub,
    required this.gradient,
    this.categorySlug,
    this.searchQuery,
    this.isNew = false,
  });
}

const themeConfigs = <ThemeConfig>[
  ThemeConfig(
    label: 'Chữa lành nhẹ',
    sub: 'Tình yêu ngọt ngào',
    gradient: [Color(0xCCFF6B9D), Color(0x66C44BED), Color(0x00FFFFFF)],
    categorySlug: 'tinh-yeu-ngot-ngao',
  ),
  ThemeConfig(
    label: 'Marvel',
    sub: 'Vũ trụ siêu anh hùng',
    gradient: [Color(0xD9E62429), Color(0x99151965), Color(0x00FFFFFF)],
    searchQuery: 'marvel',
  ),
  ThemeConfig(
    label: 'Kho tàng',
    sub: 'Kho phim đồ sộ',
    gradient: [Color(0xBFE6A017), Color(0x66C44BED), Color(0x00FFFFFF)],
    isNew: true,
  ),
  ThemeConfig(
    label: 'Anime mới',
    sub: 'Hoạt hình mới nhất',
    gradient: [Color(0xD94A9EFF), Color(0x80C44BED), Color(0x00FFFFFF)],
    categorySlug: 'hoat-hinh',
  ),
  ThemeConfig(
    label: 'Cổ trang đậm',
    sub: 'Kiếm hiệp xưa',
    gradient: [Color(0xCCFF9A3C), Color(0x59E62429), Color(0x00FFFFFF)],
    categorySlug: 'co-trang',
  ),
  ThemeConfig(
    label: 'Tội phạm gay cấn',
    sub: 'Phim tội phạm đỉnh cao',
    gradient: [Color(0xB322D3EE), Color(0x664A9EFF), Color(0x00FFFFFF)],
    categorySlug: 'hinh-su',
  ),
  ThemeConfig(
    label: 'Hài kịch',
    sub: 'Tiếng cười không dừng',
    gradient: [Color(0xD97C3AED), Color(0x664A9EFF), Color(0x00FFFFFF)],
    categorySlug: 'hai',
  ),
];

final themeMoviesProvider =
    FutureProvider.autoDispose.family<List<Movie>, int>((ref, index) async {
  final config = themeConfigs[index];
  final api = ref.read(apiClientProvider);

  if (config.searchQuery != null) {
    final response = await api.get(
      ApiEndpoints.search,
      params: {'keyword': config.searchQuery, 'limit': 8},
    );
    return ListResponse<Movie>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Movie.fromJson(json),
    ).items;
  }

  if (config.isNew) {
    final response = await api.get(ApiEndpoints.newMovies, params: {'page': 1});
    return ListResponse<Movie>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Movie.fromJson(json),
    ).items;
  }

  final response = await api.get(
    ApiEndpoints.categoryMovies(config.categorySlug!),
    params: {'page': 1, 'limit': 8},
  );
  return ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  ).items;
});

// ============================================================
// Danh mục trên trang chủ (6 nhóm như web `index.astro`)
// ============================================================

class HomeCategory {
  final String slug;
  final String name;

  const HomeCategory({required this.slug, required this.name});
}

const homeCategories = <HomeCategory>[
  HomeCategory(slug: 'hanh-dong', name: 'Hành Động'),
  HomeCategory(slug: 'lang-man', name: 'Lãng Mạn'),
  HomeCategory(slug: 'kinh-di', name: 'Kinh Dị'),
  HomeCategory(slug: 'hoat-hinh', name: 'Hoạt Hình'),
  HomeCategory(slug: 'hai', name: 'Hài'),
  HomeCategory(slug: 'co-trang', name: 'Cổ Trang'),
];

final homeCategoryMoviesProvider =
    FutureProvider.family<List<Movie>, String>((ref, slug) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(
    ApiEndpoints.categoryMovies(slug),
    params: {'page': 1, 'limit': 10},
  );
  return ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  ).items;
});
