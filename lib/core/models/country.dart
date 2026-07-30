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
    if (json.containsKey('id') && !json.containsKey('_id')) {
      json = Map<String, dynamic>.from(json)..['_id'] = json['id'];
    }
    return _$CountryFromJson(json);
  }
}
