import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/movie_detail_response.dart';
import '../../home/providers/home_provider.dart';

String _resolveStreamUrl(String linkEmbed) {
  final uri = Uri.parse(linkEmbed);
  if (linkEmbed.endsWith('.m3u8') || linkEmbed.endsWith('.mp4')) {
    return linkEmbed;
  }
  if (uri.host.contains('streamvsmov.com') && uri.pathSegments.length >= 2) {
    final hash = uri.pathSegments.last;
    return '${uri.scheme}://${uri.host}/stream/$hash/master.m3u8';
  }
  return linkEmbed;
}

final watchProvider =
    FutureProvider.family<String?, WatchParams>((ref, params) async {
  final api = ref.read(apiClientProvider);
  final response =
      await api.get(ApiEndpoints.movieDetail(params.movieSlug));
  final data = MovieDetailResponse.fromJson(response.data as Map<String, dynamic>);
  final movie = data.movie;
  if (movie == null) return null;

  for (final server in movie.episodes) {
    for (final ep in server.serverData) {
      if (ep.slug == params.episodeSlug) {
        return _resolveStreamUrl(ep.linkEmbed);
      }
    }
  }
  return null;
});

class WatchParams {
  final String movieSlug;
  final String episodeSlug;

  const WatchParams({
    required this.movieSlug,
    required this.episodeSlug,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchParams &&
          movieSlug == other.movieSlug &&
          episodeSlug == other.episodeSlug;

  @override
  int get hashCode => Object.hash(movieSlug, episodeSlug);
}
