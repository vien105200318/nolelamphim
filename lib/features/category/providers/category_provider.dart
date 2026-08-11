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

class CategoryQuery {
  final String type; // 'the-loai' | 'quoc-gia' | 'nam'
  final String slug;
  final String? subType; // 'series' | 'single'
  final String? status; // 'ongoing' | 'completed'
  final String? year;
  final String? country;
  final int page;

  const CategoryQuery({
    required this.type,
    required this.slug,
    this.subType,
    this.status,
    this.year,
    this.country,
    this.page = 1,
  });

  @override
  bool operator ==(Object other) =>
      other is CategoryQuery &&
      other.type == type &&
      other.slug == slug &&
      other.subType == subType &&
      other.status == status &&
      other.year == year &&
      other.country == country &&
      other.page == page;

  @override
  int get hashCode =>
      Object.hash(type, slug, subType, status, year, country, page);
}

final categoryListProvider =
    FutureProvider.autoDispose.family<PagedMovies, CategoryQuery>(
        (ref, query) async {
  final api = ref.read(apiClientProvider);
  final params = <String, dynamic>{'page': query.page, 'limit': 24};
  if (query.type == 'the-loai') {
    if (query.subType != null) params['type'] = query.subType;
    if (query.status != null) params['status'] = query.status;
    if (query.year != null) params['year'] = query.year;
    if (query.country != null) params['country'] = query.country;
  } else if (query.type == 'quoc-gia') {
    if (query.subType != null) params['type'] = query.subType;
    if (query.status != null) params['status'] = query.status;
    if (query.year != null) params['year'] = query.year;
  } else {
    if (query.subType != null) params['type'] = query.subType;
    if (query.status != null) params['status'] = query.status;
  }
  final path = switch (query.type) {
    'the-loai' => ApiEndpoints.categoryMovies(query.slug),
    'quoc-gia' => ApiEndpoints.countryMovies(query.slug),
    _ => ApiEndpoints.yearMovies(query.slug),
  };
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
