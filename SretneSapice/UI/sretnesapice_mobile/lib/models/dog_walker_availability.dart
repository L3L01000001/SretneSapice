import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';

part 'dog_walker_availability.g.dart';

@JsonSerializable()
class DogWalkerAvailability {
  int? dogWalkerId;
  DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  String? availabilityStatus;
  DogWalker? dogWalker;

  DogWalkerAvailability(
    this.dogWalkerId,
    this.date,
    this.startTime,
    this.endTime,
    this.availabilityStatus,
    this.dogWalker,
  );

  factory DogWalkerAvailability.fromJson(Map<String, dynamic> json) =>
      _$DogWalkerAvailabilityFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DogWalkerAvailabilityToJson(this);
}
