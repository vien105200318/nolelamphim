// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MovieDetail _$MovieDetailFromJson(Map<String, dynamic> json) {
  return _MovieDetail.fromJson(json);
}

/// @nodoc
mixin _$MovieDetail {
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
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'trailer_url')
  String? get trailerUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_copyright')
  bool? get isCopyright => throw _privateConstructorUsedError;
  @JsonKey(name: 'keywords')
  List<String> get keywords => throw _privateConstructorUsedError;
  int? get view => throw _privateConstructorUsedError;
  bool? get chieurap => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_docquyen')
  bool? get subDocquyen => throw _privateConstructorUsedError;
  String? get showtimes => throw _privateConstructorUsedError;
  @JsonKey(name: 'actor')
  List<String> get actors => throw _privateConstructorUsedError;
  @JsonKey(name: 'director')
  List<String> get directors => throw _privateConstructorUsedError;
  @JsonKey(name: 'category')
  List<Category> get categories => throw _privateConstructorUsedError;
  @JsonKey(name: 'country')
  List<Country> get countries => throw _privateConstructorUsedError;
  List<EpisodeServer> get episodes => throw _privateConstructorUsedError;

  /// Serializes this MovieDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MovieDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovieDetailCopyWith<MovieDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieDetailCopyWith<$Res> {
  factory $MovieDetailCopyWith(
    MovieDetail value,
    $Res Function(MovieDetail) then,
  ) = _$MovieDetailCopyWithImpl<$Res, MovieDetail>;
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
    String? content,
    @JsonKey(name: 'trailer_url') String? trailerUrl,
    @JsonKey(name: 'is_copyright') bool? isCopyright,
    @JsonKey(name: 'keywords') List<String> keywords,
    int? view,
    bool? chieurap,
    @JsonKey(name: 'sub_docquyen') bool? subDocquyen,
    String? showtimes,
    @JsonKey(name: 'actor') List<String> actors,
    @JsonKey(name: 'director') List<String> directors,
    @JsonKey(name: 'category') List<Category> categories,
    @JsonKey(name: 'country') List<Country> countries,
    List<EpisodeServer> episodes,
  });
}

/// @nodoc
class _$MovieDetailCopyWithImpl<$Res, $Val extends MovieDetail>
    implements $MovieDetailCopyWith<$Res> {
  _$MovieDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovieDetail
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
    Object? content = freezed,
    Object? trailerUrl = freezed,
    Object? isCopyright = freezed,
    Object? keywords = null,
    Object? view = freezed,
    Object? chieurap = freezed,
    Object? subDocquyen = freezed,
    Object? showtimes = freezed,
    Object? actors = null,
    Object? directors = null,
    Object? categories = null,
    Object? countries = null,
    Object? episodes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            originName: freezed == originName
                ? _value.originName
                : originName // ignore: cast_nullable_to_non_nullable
                      as String?,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            posterUrl: freezed == posterUrl
                ? _value.posterUrl
                : posterUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbUrl: freezed == thumbUrl
                ? _value.thumbUrl
                : thumbUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            year: freezed == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int?,
            quality: freezed == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                      as String?,
            lang: freezed == lang
                ? _value.lang
                : lang // ignore: cast_nullable_to_non_nullable
                      as String?,
            time: freezed == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            episodeCurrent: freezed == episodeCurrent
                ? _value.episodeCurrent
                : episodeCurrent // ignore: cast_nullable_to_non_nullable
                      as String?,
            episodeTotal: freezed == episodeTotal
                ? _value.episodeTotal
                : episodeTotal // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            trailerUrl: freezed == trailerUrl
                ? _value.trailerUrl
                : trailerUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCopyright: freezed == isCopyright
                ? _value.isCopyright
                : isCopyright // ignore: cast_nullable_to_non_nullable
                      as bool?,
            keywords: null == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            view: freezed == view
                ? _value.view
                : view // ignore: cast_nullable_to_non_nullable
                      as int?,
            chieurap: freezed == chieurap
                ? _value.chieurap
                : chieurap // ignore: cast_nullable_to_non_nullable
                      as bool?,
            subDocquyen: freezed == subDocquyen
                ? _value.subDocquyen
                : subDocquyen // ignore: cast_nullable_to_non_nullable
                      as bool?,
            showtimes: freezed == showtimes
                ? _value.showtimes
                : showtimes // ignore: cast_nullable_to_non_nullable
                      as String?,
            actors: null == actors
                ? _value.actors
                : actors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            directors: null == directors
                ? _value.directors
                : directors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<Category>,
            countries: null == countries
                ? _value.countries
                : countries // ignore: cast_nullable_to_non_nullable
                      as List<Country>,
            episodes: null == episodes
                ? _value.episodes
                : episodes // ignore: cast_nullable_to_non_nullable
                      as List<EpisodeServer>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MovieDetailImplCopyWith<$Res>
    implements $MovieDetailCopyWith<$Res> {
  factory _$$MovieDetailImplCopyWith(
    _$MovieDetailImpl value,
    $Res Function(_$MovieDetailImpl) then,
  ) = __$$MovieDetailImplCopyWithImpl<$Res>;
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
    String? content,
    @JsonKey(name: 'trailer_url') String? trailerUrl,
    @JsonKey(name: 'is_copyright') bool? isCopyright,
    @JsonKey(name: 'keywords') List<String> keywords,
    int? view,
    bool? chieurap,
    @JsonKey(name: 'sub_docquyen') bool? subDocquyen,
    String? showtimes,
    @JsonKey(name: 'actor') List<String> actors,
    @JsonKey(name: 'director') List<String> directors,
    @JsonKey(name: 'category') List<Category> categories,
    @JsonKey(name: 'country') List<Country> countries,
    List<EpisodeServer> episodes,
  });
}

/// @nodoc
class __$$MovieDetailImplCopyWithImpl<$Res>
    extends _$MovieDetailCopyWithImpl<$Res, _$MovieDetailImpl>
    implements _$$MovieDetailImplCopyWith<$Res> {
  __$$MovieDetailImplCopyWithImpl(
    _$MovieDetailImpl _value,
    $Res Function(_$MovieDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MovieDetail
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
    Object? content = freezed,
    Object? trailerUrl = freezed,
    Object? isCopyright = freezed,
    Object? keywords = null,
    Object? view = freezed,
    Object? chieurap = freezed,
    Object? subDocquyen = freezed,
    Object? showtimes = freezed,
    Object? actors = null,
    Object? directors = null,
    Object? categories = null,
    Object? countries = null,
    Object? episodes = null,
  }) {
    return _then(
      _$MovieDetailImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        originName: freezed == originName
            ? _value.originName
            : originName // ignore: cast_nullable_to_non_nullable
                  as String?,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        posterUrl: freezed == posterUrl
            ? _value.posterUrl
            : posterUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbUrl: freezed == thumbUrl
            ? _value.thumbUrl
            : thumbUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        year: freezed == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int?,
        quality: freezed == quality
            ? _value.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as String?,
        lang: freezed == lang
            ? _value.lang
            : lang // ignore: cast_nullable_to_non_nullable
                  as String?,
        time: freezed == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        episodeCurrent: freezed == episodeCurrent
            ? _value.episodeCurrent
            : episodeCurrent // ignore: cast_nullable_to_non_nullable
                  as String?,
        episodeTotal: freezed == episodeTotal
            ? _value.episodeTotal
            : episodeTotal // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        trailerUrl: freezed == trailerUrl
            ? _value.trailerUrl
            : trailerUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCopyright: freezed == isCopyright
            ? _value.isCopyright
            : isCopyright // ignore: cast_nullable_to_non_nullable
                  as bool?,
        keywords: null == keywords
            ? _value._keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        view: freezed == view
            ? _value.view
            : view // ignore: cast_nullable_to_non_nullable
                  as int?,
        chieurap: freezed == chieurap
            ? _value.chieurap
            : chieurap // ignore: cast_nullable_to_non_nullable
                  as bool?,
        subDocquyen: freezed == subDocquyen
            ? _value.subDocquyen
            : subDocquyen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        showtimes: freezed == showtimes
            ? _value.showtimes
            : showtimes // ignore: cast_nullable_to_non_nullable
                  as String?,
        actors: null == actors
            ? _value._actors
            : actors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        directors: null == directors
            ? _value._directors
            : directors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<Category>,
        countries: null == countries
            ? _value._countries
            : countries // ignore: cast_nullable_to_non_nullable
                  as List<Country>,
        episodes: null == episodes
            ? _value._episodes
            : episodes // ignore: cast_nullable_to_non_nullable
                  as List<EpisodeServer>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MovieDetailImpl implements _MovieDetail {
  const _$MovieDetailImpl({
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
    this.content,
    @JsonKey(name: 'trailer_url') this.trailerUrl,
    @JsonKey(name: 'is_copyright') this.isCopyright,
    @JsonKey(name: 'keywords') final List<String> keywords = const [],
    this.view,
    this.chieurap,
    @JsonKey(name: 'sub_docquyen') this.subDocquyen,
    this.showtimes,
    @JsonKey(name: 'actor') final List<String> actors = const [],
    @JsonKey(name: 'director') final List<String> directors = const [],
    @JsonKey(name: 'category') final List<Category> categories = const [],
    @JsonKey(name: 'country') final List<Country> countries = const [],
    final List<EpisodeServer> episodes = const [],
  }) : _keywords = keywords,
       _actors = actors,
       _directors = directors,
       _categories = categories,
       _countries = countries,
       _episodes = episodes;

  factory _$MovieDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovieDetailImplFromJson(json);

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
  final String? content;
  @override
  @JsonKey(name: 'trailer_url')
  final String? trailerUrl;
  @override
  @JsonKey(name: 'is_copyright')
  final bool? isCopyright;
  final List<String> _keywords;
  @override
  @JsonKey(name: 'keywords')
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  final int? view;
  @override
  final bool? chieurap;
  @override
  @JsonKey(name: 'sub_docquyen')
  final bool? subDocquyen;
  @override
  final String? showtimes;
  final List<String> _actors;
  @override
  @JsonKey(name: 'actor')
  List<String> get actors {
    if (_actors is EqualUnmodifiableListView) return _actors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actors);
  }

  final List<String> _directors;
  @override
  @JsonKey(name: 'director')
  List<String> get directors {
    if (_directors is EqualUnmodifiableListView) return _directors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_directors);
  }

  final List<Category> _categories;
  @override
  @JsonKey(name: 'category')
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<Country> _countries;
  @override
  @JsonKey(name: 'country')
  List<Country> get countries {
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_countries);
  }

  final List<EpisodeServer> _episodes;
  @override
  @JsonKey()
  List<EpisodeServer> get episodes {
    if (_episodes is EqualUnmodifiableListView) return _episodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_episodes);
  }

  @override
  String toString() {
    return 'MovieDetail(id: $id, name: $name, originName: $originName, slug: $slug, posterUrl: $posterUrl, thumbUrl: $thumbUrl, year: $year, quality: $quality, lang: $lang, time: $time, type: $type, status: $status, episodeCurrent: $episodeCurrent, episodeTotal: $episodeTotal, content: $content, trailerUrl: $trailerUrl, isCopyright: $isCopyright, keywords: $keywords, view: $view, chieurap: $chieurap, subDocquyen: $subDocquyen, showtimes: $showtimes, actors: $actors, directors: $directors, categories: $categories, countries: $countries, episodes: $episodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieDetailImpl &&
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
            (identical(other.content, content) || other.content == content) &&
            (identical(other.trailerUrl, trailerUrl) ||
                other.trailerUrl == trailerUrl) &&
            (identical(other.isCopyright, isCopyright) ||
                other.isCopyright == isCopyright) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.chieurap, chieurap) ||
                other.chieurap == chieurap) &&
            (identical(other.subDocquyen, subDocquyen) ||
                other.subDocquyen == subDocquyen) &&
            (identical(other.showtimes, showtimes) ||
                other.showtimes == showtimes) &&
            const DeepCollectionEquality().equals(other._actors, _actors) &&
            const DeepCollectionEquality().equals(
              other._directors,
              _directors,
            ) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(
              other._countries,
              _countries,
            ) &&
            const DeepCollectionEquality().equals(other._episodes, _episodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
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
    content,
    trailerUrl,
    isCopyright,
    const DeepCollectionEquality().hash(_keywords),
    view,
    chieurap,
    subDocquyen,
    showtimes,
    const DeepCollectionEquality().hash(_actors),
    const DeepCollectionEquality().hash(_directors),
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_countries),
    const DeepCollectionEquality().hash(_episodes),
  ]);

  /// Create a copy of MovieDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieDetailImplCopyWith<_$MovieDetailImpl> get copyWith =>
      __$$MovieDetailImplCopyWithImpl<_$MovieDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovieDetailImplToJson(this);
  }
}

abstract class _MovieDetail implements MovieDetail {
  const factory _MovieDetail({
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
    final String? content,
    @JsonKey(name: 'trailer_url') final String? trailerUrl,
    @JsonKey(name: 'is_copyright') final bool? isCopyright,
    @JsonKey(name: 'keywords') final List<String> keywords,
    final int? view,
    final bool? chieurap,
    @JsonKey(name: 'sub_docquyen') final bool? subDocquyen,
    final String? showtimes,
    @JsonKey(name: 'actor') final List<String> actors,
    @JsonKey(name: 'director') final List<String> directors,
    @JsonKey(name: 'category') final List<Category> categories,
    @JsonKey(name: 'country') final List<Country> countries,
    final List<EpisodeServer> episodes,
  }) = _$MovieDetailImpl;

  factory _MovieDetail.fromJson(Map<String, dynamic> json) =
      _$MovieDetailImpl.fromJson;

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
  String? get content;
  @override
  @JsonKey(name: 'trailer_url')
  String? get trailerUrl;
  @override
  @JsonKey(name: 'is_copyright')
  bool? get isCopyright;
  @override
  @JsonKey(name: 'keywords')
  List<String> get keywords;
  @override
  int? get view;
  @override
  bool? get chieurap;
  @override
  @JsonKey(name: 'sub_docquyen')
  bool? get subDocquyen;
  @override
  String? get showtimes;
  @override
  @JsonKey(name: 'actor')
  List<String> get actors;
  @override
  @JsonKey(name: 'director')
  List<String> get directors;
  @override
  @JsonKey(name: 'category')
  List<Category> get categories;
  @override
  @JsonKey(name: 'country')
  List<Country> get countries;
  @override
  List<EpisodeServer> get episodes;

  /// Create a copy of MovieDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovieDetailImplCopyWith<_$MovieDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
