import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
class Movie with _$Movie {
  const factory Movie({
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
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final cleaned = Map<String, dynamic>.from(json);
    for (final key in const [
      'origin_name',
      'poster_url',
      'thumb_url',
      'quality',
      'lang',
      'time',
      'type',
      'status',
      'episode_current',
      'episode_total',
    ]) {
      final value = cleaned[key];
      if (value != null && value is! String) {
        cleaned[key] = null;
      }
    }
    return _$MovieFromJson(cleaned);
  }
}
