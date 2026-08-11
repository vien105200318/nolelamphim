import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/list_response.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/movie_detail_response.dart';
import '../../home/providers/home_provider.dart';

final movieDetailProvider =
    FutureProvider.family<MovieDetailResponse, String>((ref, slug) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.movieDetail(slug));
  return MovieDetailResponse.fromJson(response.data as Map<String, dynamic>);
});

/// "Phim tương tự" (web `SimilarMovies.astro`): lấy 4 thể loại đầu, mỗi loại
/// 8 phim, gộp bỏ trùng + loại phim hiện tại, tối đa 6.
final similarMoviesProvider =
    FutureProvider.autoDispose.family<List<Movie>, String>((ref, slug) async {
  final api = ref.read(apiClientProvider);
  final detail = await ref.watch(movieDetailProvider(slug).future);
  final categories = detail.movie?.categories ?? const [];

  final seen = <int>{};
  final result = <Movie>[];
  for (final category in categories.take(4)) {
    if (result.length >= 6) break;
    try {
      final response = await api.get(
        ApiEndpoints.categoryMovies(category.slug),
        params: {'page': 1, 'limit': 8},
      );
      final items = ListResponse<Movie>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      ).items;
      for (final m in items) {
        if (m.slug == slug || seen.contains(m.id)) continue;
        seen.add(m.id);
        result.add(m);
        if (result.length >= 6) break;
      }
    } catch (_) {
      continue;
    }
  }
  return result;
});
