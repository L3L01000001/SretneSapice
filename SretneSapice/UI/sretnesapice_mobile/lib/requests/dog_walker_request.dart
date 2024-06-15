import 'package:json_annotation/json_annotation.dart';

part 'dog_walker_request.g.dart';

@JsonSerializable()
class DogWalkerRequest {
  String? name;
  String? surname;
  int? age;
  String? phone;
  int? cityID;
  String? experience;
  String? profilePhoto;

  DogWalkerRequest() {}

  factory DogWalkerRequest.fromJson(Map<String, dynamic> json) =>
      _$DogWalkerRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DogWalkerRequestToJson(this);
}
