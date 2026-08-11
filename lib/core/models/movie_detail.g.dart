// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IMDbInfoImpl _$$IMDbInfoImplFromJson(Map<String, dynamic> json) =>
    _$IMDbInfoImpl(id: json['id'] as String?);

Map<String, dynamic> _$$IMDbInfoImplToJson(_$IMDbInfoImpl instance) =>
    <String, dynamic>{'id': instance.id};

_$MovieDetailImpl _$$MovieDetailImplFromJson(
  Map<String, dynamic> json,
) => _$MovieDetailImpl(
  id: (json['_id'] as num).toInt(),
  name: json['name'] as String,
  originName: json['origin_name'] as String?,
  slug: json['slug'] as String,
  posterUrl: json['poster_url'] as String?,
  thumbUrl: json['thumb_url'] as String?,
  year: (json['year'] as num?)?.toInt(),
  quality: json['quality'] as String?,
  lang: json['lang'] as String?,
  time: json['time'] as String?,
  type: json['type'] as String?,
  status: json['status'] as String?,
  episodeCurrent: json['episode_current'] as String?,
  episodeTotal: json['episode_total'] as String?,
  content: json['content'] as String?,
  trailerUrl: json['trailer_url'] as String?,
  isCopyright: json['is_copyright'] as bool?,
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  view: (json['view'] as num?)?.toInt(),
  chieurap: json['chieurap'] as bool?,
  subDocquyen: json['sub_docquyen'] as bool?,
  showtimes: json['showtimes'] as String?,
  actors:
      (json['actor'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  directors:
      (json['director'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  categories:
      (json['category'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  countries:
      (json['country'] as List<dynamic>?)
          ?.map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  episodes:
      (json['episodes'] as List<dynamic>?)
          ?.map((e) => EpisodeServer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tmdb:
      json['tmdb'] == null
          ? null
          : TMDbInfo.fromJson(json['tmdb'] as Map<String, dynamic>),
  imdb:
      json['imdb'] == null
          ? const IMDbInfo()
          : IMDbInfo.fromJson(json['imdb'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$MovieDetailImplToJson(_$MovieDetailImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'origin_name': instance.originName,
      'slug': instance.slug,
      'poster_url': instance.posterUrl,
      'thumb_url': instance.thumbUrl,
      'year': instance.year,
      'quality': instance.quality,
      'lang': instance.lang,
      'time': instance.time,
      'type': instance.type,
      'status': instance.status,
      'episode_current': instance.episodeCurrent,
      'episode_total': instance.episodeTotal,
      'content': instance.content,
      'trailer_url': instance.trailerUrl,
      'is_copyright': instance.isCopyright,
      'keywords': instance.keywords,
      'view': instance.view,
      'chieurap': instance.chieurap,
      'sub_docquyen': instance.subDocquyen,
      'showtimes': instance.showtimes,
      'actor': instance.actors,
      'director': instance.directors,
      'category': instance.categories,
      'country': instance.countries,
      'episodes': instance.episodes,
      'tmdb': instance.tmdb,
      'imdb': instance.imdb,
    };
