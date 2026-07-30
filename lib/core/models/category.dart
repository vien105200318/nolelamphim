import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: '_id') required int id,
    required String name,
    required String slug,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') && !json.containsKey('_id')) {
      json = Map<String, dynamic>.from(json)..['_id'] = json['id'];
    }
    return _$CategoryFromJson(json);
  }
}
