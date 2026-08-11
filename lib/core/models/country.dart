import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';
part 'country.g.dart';

@freezed
class Country with _$Country {
  const factory Country({
    @JsonKey(name: '_id') required int id,
    required String name,
    required String slug,
  }) = _Country;

  factory Country.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    map['_id'] = map['_id'] ?? map['id'] ?? 0;
    return _$CountryFromJson(map);
  }
}
