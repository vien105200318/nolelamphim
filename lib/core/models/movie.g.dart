// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
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
);

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
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
    };
