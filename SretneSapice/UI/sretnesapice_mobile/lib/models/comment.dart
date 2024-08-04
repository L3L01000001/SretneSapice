import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/comment_like.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int? commentId;
  int? postId;
  int? userId;
  String? commentContent;
  String? timestamp;
  int? likesCount;
  User? user;
  List<CommentLike> commentLikes;

  Comment(this.commentId, this.postId, this.userId, this.commentContent,
      this.timestamp, this.likesCount, this.user, this.commentLikes);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
