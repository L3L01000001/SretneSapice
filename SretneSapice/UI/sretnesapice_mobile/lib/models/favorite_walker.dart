import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'favorite_walker.g.dart';

@JsonSerializable()
class FavoriteWalker {
  int? favoriteWalkerId;
  int? userId;
  int? dogWalkerId;
  User? user;
  DogWalker? dogWalker;

  FavoriteWalker(this.favoriteWalkerId, this.userId, this.dogWalkerId,
      this.dogWalker, this.user);

  factory FavoriteWalker.fromJson(Map<String, dynamic> json) =>
      _$FavoriteWalkerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FavoriteWalkerToJson(this);
}
