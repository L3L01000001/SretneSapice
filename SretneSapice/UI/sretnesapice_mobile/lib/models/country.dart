import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  int? countryId;
  String? countryName;

  Country(this.countryId, this.countryName);

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
