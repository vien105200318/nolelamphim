import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
import 'country.dart';
import 'episode.dart';

part 'movie_detail.freezed.dart';
part 'movie_detail.g.dart';

@freezed
class MovieDetail with _$MovieDetail {
  const factory MovieDetail({
    @JsonKey(name: '_id') required int id,
    required String name,
    @JsonKey(name: 'origin_name') String? originName,
    required String slug,
    @JsonKey(name: 'poster_url') String? posterUrl,
    @JsonKey(name: 'thumb_url') String? thumbUrl,
    int? year,
    String? quality,
    String? lang,
    String? time,
    String? type,
    String? status,
    @JsonKey(name: 'episode_current') String? episodeCurrent,
    @JsonKey(name: 'episode_total') String? episodeTotal,
    String? content,
    @JsonKey(name: 'trailer_url') String? trailerUrl,
    @JsonKey(name: 'is_copyright') bool? isCopyright,
    @JsonKey(name: 'keywords') @Default([]) List<String> keywords,
    int? view,
    bool? chieurap,
    @JsonKey(name: 'sub_docquyen') bool? subDocquyen,
    String? showtimes,
    @JsonKey(name: 'actor') @Default([]) List<String> actors,
    @JsonKey(name: 'director') @Default([]) List<String> directors,
    @JsonKey(name: 'category') @Default([]) List<Category> categories,
    @JsonKey(name: 'country') @Default([]) List<Country> countries,
    @Default([]) List<EpisodeServer> episodes,
  }) = _MovieDetail;

  factory MovieDetail.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailFromJson(json);
}
