import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/comment.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'comment_like.g.dart';

@JsonSerializable()
class CommentLike {
  int? likeId;
  int? commentId;
  int? userId;
  String? timestamp;
  User? user;
  Comment? comment;

  CommentLike(this.likeId, this.commentId, this.userId, this.timestamp,
      this.user, this.comment);

  factory CommentLike.fromJson(Map<String, dynamic> json) =>
      _$CommentLikeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CommentLikeToJson(this);
}
