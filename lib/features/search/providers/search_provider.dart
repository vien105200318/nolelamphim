import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/data_list_response.dart';
import '../../../core/models/list_response.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/category.dart';
import '../../../core/models/country.dart';
import '../../../core/models/year_item.dart';
import '../../home/providers/home_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  final api = ref.read(apiClientProvider);
  final response = await api.get(
    ApiEndpoints.search,
    params: {'keyword': query, 'limit': 20},
  );
  final data = ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  );
  return data.items;
});

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
