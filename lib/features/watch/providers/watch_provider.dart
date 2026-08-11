import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/movie_detail.dart';
import '../../../core/models/movie_detail_response.dart';
import '../../home/providers/home_provider.dart';

String resolveStreamUrl(String linkEmbed) {
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

/// Dữ liệu trang xem (spec §5.5): movie + server/tập hiện tại. `resolveStreamUrl`
/// dùng ở màn hình để đổi server.
final watchDataProvider =
    FutureProvider.autoDispose.family<WatchData?, WatchParams>((ref, params) async {
  final api = ref.read(apiClientProvider);
  final response =
      await api.get(ApiEndpoints.movieDetail(params.movieSlug));
  final data = MovieDetailResponse.fromJson(response.data as Map<String, dynamic>);
  final movie = data.movie;
  if (movie == null) return null;

  for (var si = 0; si < movie.episodes.length; si++) {
    final list = movie.episodes[si].serverData;
    for (var ei = 0; ei < list.length; ei++) {
      if (list[ei].slug == params.episodeSlug) {
        return WatchData(movie: movie, serverIndex: si, episodeIndex: ei);
      }
    }
  }
  return null;
});

class WatchData {
  final MovieDetail movie;
  final int serverIndex;
  final int episodeIndex;

  const WatchData({
    required this.movie,
    required this.serverIndex,
    required this.episodeIndex,
  });
}

final watchProvider =
    FutureProvider.family<String?, WatchParams>((ref, params) async {
  final data = await ref.watch(watchDataProvider(params).future);
  if (data == null) return null;
  final server = data.movie.episodes[data.serverIndex].serverData;
  if (data.episodeIndex >= server.length) return null;
  return resolveStreamUrl(server[data.episodeIndex].linkEmbed);
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
