// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Movie _$MovieFromJson(Map<String, dynamic> json) {
  return _Movie.fromJson(json);
}

/// @nodoc
mixin _$Movie {
  @JsonKey(name: '_id')
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'origin_name')
  String? get originName => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'poster_url')
  String? get posterUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumb_url')
  String? get thumbUrl => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  String? get quality => throw _privateConstructorUsedError;
  String? get lang => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'episode_current')
  String? get episodeCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'episode_total')
  String? get episodeTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'tmdb')
  TMDbInfo? get tmdb => throw _privateConstructorUsedError;

  /// Serializes this Movie to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovieCopyWith<Movie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieCopyWith<$Res> {
  factory $MovieCopyWith(Movie value, $Res Function(Movie) then) =
      _$MovieCopyWithImpl<$Res, Movie>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') int id,
    String name,
    @JsonKey(name: 'origin_name') String? originName,
    String slug,
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
  });
}

/// @nodoc
class _$MovieCopyWithImpl<$Res, $Val extends Movie>
    implements $MovieCopyWith<$Res> {
  _$MovieCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? originName = freezed,
    Object? slug = null,
    Object? posterUrl = freezed,
    Object? thumbUrl = freezed,
    Object? year = freezed,
    Object? quality = freezed,
    Object? lang = freezed,
    Object? time = freezed,
    Object? type = freezed,
    Object? status = freezed,
    Object? episodeCurrent = freezed,
    Object? episodeTotal = freezed,
    Object? tmdb = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            originName:
                freezed == originName
                    ? _value.originName
                    : originName // ignore: cast_nullable_to_non_nullable
                        as String?,
            slug:
                null == slug
                    ? _value.slug
                    : slug // ignore: cast_nullable_to_non_nullable
                        as String,
            posterUrl:
                freezed == posterUrl
                    ? _value.posterUrl
                    : posterUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            thumbUrl:
                freezed == thumbUrl
                    ? _value.thumbUrl
                    : thumbUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            year:
                freezed == year
                    ? _value.year
                    : year // ignore: cast_nullable_to_non_nullable
                        as int?,
            quality:
                freezed == quality
                    ? _value.quality
                    : quality // ignore: cast_nullable_to_non_nullable
                        as String?,
            lang:
                freezed == lang
                    ? _value.lang
                    : lang // ignore: cast_nullable_to_non_nullable
                        as String?,
            time:
                freezed == time
                    ? _value.time
                    : time // ignore: cast_nullable_to_non_nullable
                        as String?,
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
            episodeCurrent:
                freezed == episodeCurrent
                    ? _value.episodeCurrent
                    : episodeCurrent // ignore: cast_nullable_to_non_nullable
                        as String?,
            episodeTotal:
                freezed == episodeTotal
                    ? _value.episodeTotal
                    : episodeTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            tmdb:
                freezed == tmdb
                    ? _value.tmdb
                    : tmdb // ignore: cast_nullable_to_non_nullable
                        as TMDbInfo?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MovieImplCopyWith<$Res> implements $MovieCopyWith<$Res> {
  factory _$$MovieImplCopyWith(
    _$MovieImpl value,
    $Res Function(_$MovieImpl) then,
  ) = __$$MovieImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') int id,
    String name,
    @JsonKey(name: 'origin_name') String? originName,
    String slug,
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
  });
}

/// @nodoc
class __$$MovieImplCopyWithImpl<$Res>
    extends _$MovieCopyWithImpl<$Res, _$MovieImpl>
    implements _$$MovieImplCopyWith<$Res> {
  __$$MovieImplCopyWithImpl(
    _$MovieImpl _value,
    $Res Function(_$MovieImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? originName = freezed,
    Object? slug = null,
    Object? posterUrl = freezed,
    Object? thumbUrl = freezed,
    Object? year = freezed,
    Object? quality = freezed,
    Object? lang = freezed,
    Object? time = freezed,
    Object? type = freezed,
    Object? status = freezed,
    Object? episodeCurrent = freezed,
    Object? episodeTotal = freezed,
    Object? tmdb = freezed,
  }) {
    return _then(
      _$MovieImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        originName:
            freezed == originName
                ? _value.originName
                : originName // ignore: cast_nullable_to_non_nullable
                    as String?,
        slug:
            null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                    as String,
        posterUrl:
            freezed == posterUrl
                ? _value.posterUrl
                : posterUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        thumbUrl:
            freezed == thumbUrl
                ? _value.thumbUrl
                : thumbUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        year:
            freezed == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                    as int?,
        quality:
            freezed == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                    as String?,
        lang:
            freezed == lang
                ? _value.lang
                : lang // ignore: cast_nullable_to_non_nullable
                    as String?,
        time:
            freezed == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                    as String?,
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
        episodeCurrent:
            freezed == episodeCurrent
                ? _value.episodeCurrent
                : episodeCurrent // ignore: cast_nullable_to_non_nullable
                    as String?,
        episodeTotal:
            freezed == episodeTotal
                ? _value.episodeTotal
                : episodeTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        tmdb:
            freezed == tmdb
                ? _value.tmdb
                : tmdb // ignore: cast_nullable_to_non_nullable
                    as TMDbInfo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieImpl implements _Movie {
  const _$MovieImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    @JsonKey(name: 'origin_name') this.originName,
    required this.slug,
    @JsonKey(name: 'poster_url') this.posterUrl,
    @JsonKey(name: 'thumb_url') this.thumbUrl,
    this.year,
    this.quality,
    this.lang,
    this.time,
    this.type,
    this.status,
    @JsonKey(name: 'episode_current') this.episodeCurrent,
    @JsonKey(name: 'episode_total') this.episodeTotal,
    @JsonKey(name: 'tmdb') this.tmdb,
  });

  factory _$MovieImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovieImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'origin_name')
  final String? originName;
  @override
  final String slug;
  @override
  @JsonKey(name: 'poster_url')
  final String? posterUrl;
  @override
  @JsonKey(name: 'thumb_url')
  final String? thumbUrl;
  @override
  final int? year;
  @override
  final String? quality;
  @override
  final String? lang;
  @override
  final String? time;
  @override
  final String? type;
  @override
  final String? status;
  @override
  @JsonKey(name: 'episode_current')
  final String? episodeCurrent;
  @override
  @JsonKey(name: 'episode_total')
  final String? episodeTotal;
  @override
  @JsonKey(name: 'tmdb')
  final TMDbInfo? tmdb;

  @override
  String toString() {
    return 'Movie(id: $id, name: $name, originName: $originName, slug: $slug, posterUrl: $posterUrl, thumbUrl: $thumbUrl, year: $year, quality: $quality, lang: $lang, time: $time, type: $type, status: $status, episodeCurrent: $episodeCurrent, episodeTotal: $episodeTotal, tmdb: $tmdb)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.originName, originName) ||
                other.originName == originName) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.posterUrl, posterUrl) ||
                other.posterUrl == posterUrl) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.episodeCurrent, episodeCurrent) ||
                other.episodeCurrent == episodeCurrent) &&
            (identical(other.episodeTotal, episodeTotal) ||
                other.episodeTotal == episodeTotal) &&
            (identical(other.tmdb, tmdb) || other.tmdb == tmdb));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    originName,
    slug,
    posterUrl,
    thumbUrl,
    year,
    quality,
    lang,
    time,
    type,
    status,
    episodeCurrent,
    episodeTotal,
    tmdb,
  );

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieImplCopyWith<_$MovieImpl> get copyWith =>
      __$$MovieImplCopyWithImpl<_$MovieImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovieImplToJson(this);
  }
}

abstract class _Movie implements Movie {
  const factory _Movie({
    @JsonKey(name: '_id') required final int id,
    required final String name,
    @JsonKey(name: 'origin_name') final String? originName,
    required final String slug,
    @JsonKey(name: 'poster_url') final String? posterUrl,
    @JsonKey(name: 'thumb_url') final String? thumbUrl,
    final int? year,
    final String? quality,
    final String? lang,
    final String? time,
    final String? type,
    final String? status,
    @JsonKey(name: 'episode_current') final String? episodeCurrent,
    @JsonKey(name: 'episode_total') final String? episodeTotal,
    @JsonKey(name: 'tmdb') final TMDbInfo? tmdb,
  }) = _$MovieImpl;

  factory _Movie.fromJson(Map<String, dynamic> json) = _$MovieImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'origin_name')
  String? get originName;
  @override
  String get slug;
  @override
  @JsonKey(name: 'poster_url')
  String? get posterUrl;
  @override
  @JsonKey(name: 'thumb_url')
  String? get thumbUrl;
  @override
  int? get year;
  @override
  String? get quality;
  @override
  String? get lang;
  @override
  String? get time;
  @override
  String? get type;
  @override
  String? get status;
  @override
  @JsonKey(name: 'episode_current')
  String? get episodeCurrent;
  @override
  @JsonKey(name: 'episode_total')
  String? get episodeTotal;
  @override
  @JsonKey(name: 'tmdb')
  TMDbInfo? get tmdb;

  /// Create a copy of Movie
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovieImplCopyWith<_$MovieImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
