import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'walker_review.g.dart';

@JsonSerializable()
class WalkerReview {
  int? reviewId;
  int? dogWalkerId;
  int? userId;
  int? rating;
  String? reviewText;
  String? timestamp;
  DogWalker? dogWalker;
  User? user;

  WalkerReview(this.reviewId, this.dogWalkerId, this.userId, this.rating,
      this.reviewText, this.timestamp, this.dogWalker, this.user);

  factory WalkerReview.fromJson(Map<String, dynamic> json) =>
      _$WalkerReviewFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$WalkerReviewToJson(this);
}
