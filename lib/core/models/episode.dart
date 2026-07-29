import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
class EpisodeServer with _$EpisodeServer {
  const factory EpisodeServer({
    @JsonKey(name: 'server_name') required String serverName,
    @JsonKey(name: 'server_data') required List<EpisodeData> serverData,
  }) = _EpisodeServer;

  factory EpisodeServer.fromJson(Map<String, dynamic> json) =>
      _$EpisodeServerFromJson(json);
}

@freezed
class EpisodeData with _$EpisodeData {
  const factory EpisodeData({
    required String name,
    required String slug,
    String? filename,
    @JsonKey(name: 'link_embed') required String linkEmbed,
  }) = _EpisodeData;

  factory EpisodeData.fromJson(Map<String, dynamic> json) =>
      _$EpisodeDataFromJson(json);
}
