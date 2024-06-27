import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';

part 'dog_walker_location.g.dart';

@JsonSerializable()
class DogWalkerLocation {
  int? dogWalkerId;
  DateTime? timestamp;
  double? latitude;
  double? longitude;
  DogWalker? dogWalker;

  DogWalkerLocation(
    this.dogWalkerId,
    this.timestamp,
    this.latitude,
    this.longitude,
    this.dogWalker,
  );

  factory DogWalkerLocation.fromJson(Map<String, dynamic> json) =>
      _$DogWalkerLocationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DogWalkerLocationToJson(this);
}
