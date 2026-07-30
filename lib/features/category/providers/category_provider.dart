import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/list_response.dart';
import '../../../core/models/movie.dart';
import '../../home/providers/home_provider.dart';

final categoryMoviesProvider =
    FutureProvider.family<List<Movie>, String>((ref, slug) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(
    ApiEndpoints.categoryMovies(slug),
    params: {'page': 1, 'limit': 24},
  );
  final data = ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  );
  return data.items;
});

final countryMoviesProvider =
    FutureProvider.family<List<Movie>, String>((ref, slug) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(
    ApiEndpoints.countryMovies(slug),
    params: {'page': 1, 'limit': 24},
  );
  final data = ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  );
  return data.items;
});

final yearMoviesProvider =
    FutureProvider.family<List<Movie>, String>((ref, year) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(
    ApiEndpoints.yearMovies(year),
    params: {'page': 1, 'limit': 24},
  );
  final data = ListResponse<Movie>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Movie.fromJson(json),
  );
  return data.items;
});
