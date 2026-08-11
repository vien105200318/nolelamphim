// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EpisodeServerImpl _$$EpisodeServerImplFromJson(Map<String, dynamic> json) =>
    _$EpisodeServerImpl(
      serverName: json['server_name'] as String,
      serverData:
          (json['server_data'] as List<dynamic>)
              .map((e) => EpisodeData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$EpisodeServerImplToJson(_$EpisodeServerImpl instance) =>
    <String, dynamic>{
      'server_name': instance.serverName,
      'server_data': instance.serverData,
    };

_$EpisodeDataImpl _$$EpisodeDataImplFromJson(Map<String, dynamic> json) =>
    _$EpisodeDataImpl(
      name: json['name'] as String,
      slug: json['slug'] as String,
      filename: json['filename'] as String?,
      linkEmbed: json['link_embed'] as String,
    );

Map<String, dynamic> _$$EpisodeDataImplToJson(_$EpisodeDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'filename': instance.filename,
      'link_embed': instance.linkEmbed,
    };
