import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/data_list_response.dart';
import '../../../core/models/list_response.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/category.dart';
import '../../../core/models/country.dart';
import '../../../core/models/year_item.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../home/providers/home_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchFilter {
  final String type;
  final String label;
  final String value;

  const SearchFilter({
    required this.type,
    required this.label,
    required this.value,
  });
}

final searchFilterProvider = StateProvider<SearchFilter?>((ref) => null);

final searchPageProvider = StateProvider<int>((ref) => 1);

final searchPagedProvider = FutureProvider.autoDispose<PagedMovies>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  final filter = ref.watch(searchFilterProvider);
  final page = ref.watch(searchPageProvider);
  final api = ref.read(apiClientProvider);
  final params = <String, dynamic>{'page': page, 'limit': 20};
  final String path;
  if (query.isNotEmpty) {
    path = ApiEndpoints.search;
    params['keyword'] = query;
  } else if (filter != null) {
    if (filter.type == 'category') {
      path = ApiEndpoints.categoryMovies(filter.value);
    } else if (filter.type == 'country') {
      path = ApiEndpoints.countryMovies(filter.value);
    } else {
      path = ApiEndpoints.yearMovies(filter.value);
    }
  } else {
    path = ApiEndpoints.newMovies;
  }
  final response = await api.get(path, params: params);
  final map = response.data as Map<String, dynamic>;
  final items = (map['items'] as List<dynamic>?)
          ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Movie>[];
  final pagination = map['pagination'] as Map<String, dynamic>?;
  final totalPages = (pagination?['totalPages'] as num?)?.toInt() ?? 1;
  return PagedMovies(items: items, totalPages: totalPages);
});

final searchResultsProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  return (await ref.watch(searchPagedProvider.future)).items;
});

final searchSuggestionsProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return const [];
  final api = ref.read(apiClientProvider);
  final response = await api.get(
    ApiEndpoints.search,
    params: {'keyword': query, 'limit': 5},
  );
  final data = ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  );
  return data.items;
});

final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>(
        (ref) => RecentSearchesNotifier(ref.read(localStorageServiceProvider)));

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier(this._storage) : super(const []) {
    _load();
  }

  static const _storageKey = 'recent-searches';
  static const _maxItems = 8;

  final LocalStorageService _storage;

  Future<void> _load() async {
    try {
      state = await _storage.readStringList(_storageKey);
    } catch (_) {}
  }

  Future<void> add(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    final updated = [q, ...state.where((e) => e != q)].take(_maxItems).toList();
    state = updated;
    try {
      await _storage.writeStringList(_storageKey, updated);
    } catch (_) {}
  }

  Future<void> clear() async {
    state = const [];
    try {
      await _storage.writeStringList(_storageKey, const []);
    } catch (_) {}
  }
}

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.categories);
  final data = DataListResponse<Category>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Category.fromJson(json),
  );
  return data.items;
});

final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.countries);
  final data = DataListResponse<Country>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Country.fromJson(json),
  );
  return data.items;
});

final yearsProvider = FutureProvider<List<String>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.years);
  final data = DataListResponse<YearItem>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => YearItem.fromJson(json),
  );
  return data.items.map((e) => e.name).toList();
});
