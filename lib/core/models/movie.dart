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
    @JsonKey(name: 'tmdb') TMDbInfo? tmdb,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) =>
      _$MovieFromJson(_cleanJson(json));

  static Map<String, dynamic> _cleanJson(Map<String, dynamic> json) {
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
    return cleaned;
  }
}

/// `tmdb` trên API trả `{ vote_average: "8.5", vote_count, ... }`.
@JsonSerializable()
class TMDbInfo {
  final String? voteAverage;
  final int? voteCount;
  final String? id;

  const TMDbInfo({this.voteAverage, this.voteCount, this.id});

  factory TMDbInfo.fromJson(Map<String, dynamic> json) =>
      _$TMDbInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TMDbInfoToJson(this);

  String? get voteString {
    final v = double.tryParse(voteAverage ?? '');
    if (v == null || v <= 0) return null;
    return voteAverage!.replaceAll(RegExp(r'\.0+$'), '');
  }
}
