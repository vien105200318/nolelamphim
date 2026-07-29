import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/movie_detail_response.dart';
import '../../home/providers/home_provider.dart';

final movieDetailProvider =
    FutureProvider.family<MovieDetailResponse, String>((ref, slug) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.movieDetail(slug));
  return MovieDetailResponse.fromJson(response.data as Map<String, dynamic>);
});
