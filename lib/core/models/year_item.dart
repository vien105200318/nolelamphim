import 'package:freezed_annotation/freezed_annotation.dart';

part 'year_item.freezed.dart';
part 'year_item.g.dart';

@freezed
class YearItem with _$YearItem {
  const factory YearItem({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String slug,
  }) = _YearItem;

  factory YearItem.fromJson(Map<String, dynamic> json) =>
      _$YearItemFromJson(json);
}
