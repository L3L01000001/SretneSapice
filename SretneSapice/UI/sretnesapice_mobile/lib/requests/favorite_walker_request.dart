import 'package:json_annotation/json_annotation.dart';

part 'favorite_walker_request.g.dart';

@JsonSerializable()
class FavoriteWalkerRequest {
  int? dogWalkerId;

  FavoriteWalkerRequest() {}

  factory FavoriteWalkerRequest.fromJson(Map<String, dynamic> json) =>
      _$FavoriteWalkerRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FavoriteWalkerRequestToJson(this);
}
