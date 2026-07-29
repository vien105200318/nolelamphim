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
