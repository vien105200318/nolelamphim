// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

YearItem _$YearItemFromJson(Map<String, dynamic> json) {
  return _YearItem.fromJson(json);
}

/// @nodoc
mixin _$YearItem {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  /// Serializes this YearItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of YearItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $YearItemCopyWith<YearItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YearItemCopyWith<$Res> {
  factory $YearItemCopyWith(YearItem value, $Res Function(YearItem) then) =
      _$YearItemCopyWithImpl<$Res, YearItem>;
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String name, String slug});
}

/// @nodoc
class _$YearItemCopyWithImpl<$Res, $Val extends YearItem>
    implements $YearItemCopyWith<$Res> {
  _$YearItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of YearItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? slug = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$YearItemImplCopyWith<$Res>
    implements $YearItemCopyWith<$Res> {
  factory _$$YearItemImplCopyWith(
    _$YearItemImpl value,
    $Res Function(_$YearItemImpl) then,
  ) = __$$YearItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String name, String slug});
}

/// @nodoc
class __$$YearItemImplCopyWithImpl<$Res>
    extends _$YearItemCopyWithImpl<$Res, _$YearItemImpl>
    implements _$$YearItemImplCopyWith<$Res> {
  __$$YearItemImplCopyWithImpl(
    _$YearItemImpl _value,
    $Res Function(_$YearItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of YearItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? slug = null}) {
    return _then(
      _$YearItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$YearItemImpl implements _YearItem {
  const _$YearItemImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    required this.slug,
  });

  factory _$YearItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$YearItemImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String slug;

  @override
  String toString() {
    return 'YearItem(id: $id, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YearItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  /// Create a copy of YearItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YearItemImplCopyWith<_$YearItemImpl> get copyWith =>
      __$$YearItemImplCopyWithImpl<_$YearItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$YearItemImplToJson(this);
  }
}

abstract class _YearItem implements YearItem {
  const factory _YearItem({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    required final String slug,
  }) = _$YearItemImpl;

  factory _YearItem.fromJson(Map<String, dynamic> json) =
      _$YearItemImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String get slug;

  /// Create a copy of YearItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YearItemImplCopyWith<_$YearItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
