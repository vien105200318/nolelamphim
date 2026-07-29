// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EpisodeServer _$EpisodeServerFromJson(Map<String, dynamic> json) {
  return _EpisodeServer.fromJson(json);
}

/// @nodoc
mixin _$EpisodeServer {
  @JsonKey(name: 'server_name')
  String get serverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'server_data')
  List<EpisodeData> get serverData => throw _privateConstructorUsedError;

  /// Serializes this EpisodeServer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EpisodeServer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EpisodeServerCopyWith<EpisodeServer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EpisodeServerCopyWith<$Res> {
  factory $EpisodeServerCopyWith(
    EpisodeServer value,
    $Res Function(EpisodeServer) then,
  ) = _$EpisodeServerCopyWithImpl<$Res, EpisodeServer>;
  @useResult
  $Res call({
    @JsonKey(name: 'server_name') String serverName,
    @JsonKey(name: 'server_data') List<EpisodeData> serverData,
  });
}

/// @nodoc
class _$EpisodeServerCopyWithImpl<$Res, $Val extends EpisodeServer>
    implements $EpisodeServerCopyWith<$Res> {
  _$EpisodeServerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EpisodeServer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? serverName = null, Object? serverData = null}) {
    return _then(
      _value.copyWith(
            serverName: null == serverName
                ? _value.serverName
                : serverName // ignore: cast_nullable_to_non_nullable
                      as String,
            serverData: null == serverData
                ? _value.serverData
                : serverData // ignore: cast_nullable_to_non_nullable
                      as List<EpisodeData>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EpisodeServerImplCopyWith<$Res>
    implements $EpisodeServerCopyWith<$Res> {
  factory _$$EpisodeServerImplCopyWith(
    _$EpisodeServerImpl value,
    $Res Function(_$EpisodeServerImpl) then,
  ) = __$$EpisodeServerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'server_name') String serverName,
    @JsonKey(name: 'server_data') List<EpisodeData> serverData,
  });
}

/// @nodoc
class __$$EpisodeServerImplCopyWithImpl<$Res>
    extends _$EpisodeServerCopyWithImpl<$Res, _$EpisodeServerImpl>
    implements _$$EpisodeServerImplCopyWith<$Res> {
  __$$EpisodeServerImplCopyWithImpl(
    _$EpisodeServerImpl _value,
    $Res Function(_$EpisodeServerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EpisodeServer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? serverName = null, Object? serverData = null}) {
    return _then(
      _$EpisodeServerImpl(
        serverName: null == serverName
            ? _value.serverName
            : serverName // ignore: cast_nullable_to_non_nullable
                  as String,
        serverData: null == serverData
            ? _value._serverData
            : serverData // ignore: cast_nullable_to_non_nullable
                  as List<EpisodeData>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EpisodeServerImpl implements _EpisodeServer {
  const _$EpisodeServerImpl({
    @JsonKey(name: 'server_name') required this.serverName,
    @JsonKey(name: 'server_data') required final List<EpisodeData> serverData,
  }) : _serverData = serverData;

  factory _$EpisodeServerImpl.fromJson(Map<String, dynamic> json) =>
      _$$EpisodeServerImplFromJson(json);

  @override
  @JsonKey(name: 'server_name')
  final String serverName;
  final List<EpisodeData> _serverData;
  @override
  @JsonKey(name: 'server_data')
  List<EpisodeData> get serverData {
    if (_serverData is EqualUnmodifiableListView) return _serverData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serverData);
  }

  @override
  String toString() {
    return 'EpisodeServer(serverName: $serverName, serverData: $serverData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EpisodeServerImpl &&
            (identical(other.serverName, serverName) ||
                other.serverName == serverName) &&
            const DeepCollectionEquality().equals(
              other._serverData,
              _serverData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    serverName,
    const DeepCollectionEquality().hash(_serverData),
  );

  /// Create a copy of EpisodeServer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EpisodeServerImplCopyWith<_$EpisodeServerImpl> get copyWith =>
      __$$EpisodeServerImplCopyWithImpl<_$EpisodeServerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EpisodeServerImplToJson(this);
  }
}

abstract class _EpisodeServer implements EpisodeServer {
  const factory _EpisodeServer({
    @JsonKey(name: 'server_name') required final String serverName,
    @JsonKey(name: 'server_data') required final List<EpisodeData> serverData,
  }) = _$EpisodeServerImpl;

  factory _EpisodeServer.fromJson(Map<String, dynamic> json) =
      _$EpisodeServerImpl.fromJson;

  @override
  @JsonKey(name: 'server_name')
  String get serverName;
  @override
  @JsonKey(name: 'server_data')
  List<EpisodeData> get serverData;

  /// Create a copy of EpisodeServer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EpisodeServerImplCopyWith<_$EpisodeServerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EpisodeData _$EpisodeDataFromJson(Map<String, dynamic> json) {
  return _EpisodeData.fromJson(json);
}

/// @nodoc
mixin _$EpisodeData {
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get filename => throw _privateConstructorUsedError;
  @JsonKey(name: 'link_embed')
  String get linkEmbed => throw _privateConstructorUsedError;

  /// Serializes this EpisodeData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EpisodeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EpisodeDataCopyWith<EpisodeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EpisodeDataCopyWith<$Res> {
  factory $EpisodeDataCopyWith(
    EpisodeData value,
    $Res Function(EpisodeData) then,
  ) = _$EpisodeDataCopyWithImpl<$Res, EpisodeData>;
  @useResult
  $Res call({
    String name,
    String slug,
    String? filename,
    @JsonKey(name: 'link_embed') String linkEmbed,
  });
}

/// @nodoc
class _$EpisodeDataCopyWithImpl<$Res, $Val extends EpisodeData>
    implements $EpisodeDataCopyWith<$Res> {
  _$EpisodeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EpisodeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? slug = null,
    Object? filename = freezed,
    Object? linkEmbed = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            filename: freezed == filename
                ? _value.filename
                : filename // ignore: cast_nullable_to_non_nullable
                      as String?,
            linkEmbed: null == linkEmbed
                ? _value.linkEmbed
                : linkEmbed // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EpisodeDataImplCopyWith<$Res>
    implements $EpisodeDataCopyWith<$Res> {
  factory _$$EpisodeDataImplCopyWith(
    _$EpisodeDataImpl value,
    $Res Function(_$EpisodeDataImpl) then,
  ) = __$$EpisodeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String slug,
    String? filename,
    @JsonKey(name: 'link_embed') String linkEmbed,
  });
}

/// @nodoc
class __$$EpisodeDataImplCopyWithImpl<$Res>
    extends _$EpisodeDataCopyWithImpl<$Res, _$EpisodeDataImpl>
    implements _$$EpisodeDataImplCopyWith<$Res> {
  __$$EpisodeDataImplCopyWithImpl(
    _$EpisodeDataImpl _value,
    $Res Function(_$EpisodeDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EpisodeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? slug = null,
    Object? filename = freezed,
    Object? linkEmbed = null,
  }) {
    return _then(
      _$EpisodeDataImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        filename: freezed == filename
            ? _value.filename
            : filename // ignore: cast_nullable_to_non_nullable
                  as String?,
        linkEmbed: null == linkEmbed
            ? _value.linkEmbed
            : linkEmbed // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EpisodeDataImpl implements _EpisodeData {
  const _$EpisodeDataImpl({
    required this.name,
    required this.slug,
    this.filename,
    @JsonKey(name: 'link_embed') required this.linkEmbed,
  });

  factory _$EpisodeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EpisodeDataImplFromJson(json);

  @override
  final String name;
  @override
  final String slug;
  @override
  final String? filename;
  @override
  @JsonKey(name: 'link_embed')
  final String linkEmbed;

  @override
  String toString() {
    return 'EpisodeData(name: $name, slug: $slug, filename: $filename, linkEmbed: $linkEmbed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EpisodeDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.linkEmbed, linkEmbed) ||
                other.linkEmbed == linkEmbed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, slug, filename, linkEmbed);

  /// Create a copy of EpisodeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EpisodeDataImplCopyWith<_$EpisodeDataImpl> get copyWith =>
      __$$EpisodeDataImplCopyWithImpl<_$EpisodeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EpisodeDataImplToJson(this);
  }
}

abstract class _EpisodeData implements EpisodeData {
  const factory _EpisodeData({
    required final String name,
    required final String slug,
    final String? filename,
    @JsonKey(name: 'link_embed') required final String linkEmbed,
  }) = _$EpisodeDataImpl;

  factory _EpisodeData.fromJson(Map<String, dynamic> json) =
      _$EpisodeDataImpl.fromJson;

  @override
  String get name;
  @override
  String get slug;
  @override
  String? get filename;
  @override
  @JsonKey(name: 'link_embed')
  String get linkEmbed;

  /// Create a copy of EpisodeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EpisodeDataImplCopyWith<_$EpisodeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
