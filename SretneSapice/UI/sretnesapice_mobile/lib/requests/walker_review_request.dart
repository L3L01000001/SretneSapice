import 'package:json_annotation/json_annotation.dart';

part 'walker_review_request.g.dart';

@JsonSerializable()
class WalkerReviewRequest {
  int? dogWalkerId;
  String? reviewText;
  int? rating;

  WalkerReviewRequest() {}

  factory WalkerReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$WalkerReviewRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$WalkerReviewRequestToJson(this);
}
