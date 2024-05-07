import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  int? cityID;
  String? name;
  int? countryId;

  City(this.cityID, this.name, this.countryId);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CityToJson(this);
}
