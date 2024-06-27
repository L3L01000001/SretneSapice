import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';

part 'dog_walker_location_request.g.dart';

@JsonSerializable()
class DogWalkerLocationRequest {
  int? dogWalkerId;
  DateTime? timestamp;
  double? latitude;
  double? longitude;
  DogWalker? dogWalker;

  DogWalkerLocationRequest() {}

  factory DogWalkerLocationRequest.fromJson(Map<String, dynamic> json) =>
      _$DogWalkerLocationRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DogWalkerLocationRequestToJson(this);
}
