import 'package:json_annotation/json_annotation.dart';

part 'dog_walker.g.dart';

@JsonSerializable()
class DogWalker {
  int? dogWalkerId;
  int? userId;
  String? name;
  String? surname;
  String? fullName;
  int? age;
  int? cityId;
  String? phone;
  String? experience;
  String? dogWalkerPhoto;
  int? rating;
  bool? isApproved;
  String? status;

  DogWalker(
      this.dogWalkerId,
      this.userId,
      this.name,
      this.surname,
      this.fullName,
      this.age,
      this.cityId,
      this.phone,
      this.experience,
      this.dogWalkerPhoto,
      this.rating,
      this.isApproved,
      this.status);

  factory DogWalker.fromJson(Map<String, dynamic> json) =>
      _$DogWalkerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DogWalkerToJson(this);
}
