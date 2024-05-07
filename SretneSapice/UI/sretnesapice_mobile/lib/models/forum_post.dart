import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/tag.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'forum_post.g.dart';

@JsonSerializable()
class ForumPost {
  int? postId;
  int? userId;
  String? title;
  String? postContent;
  String? timestamp;
  String? photo;
  List<Tag> tags;
  User? user;

  ForumPost(this.postId, this.userId, this.title, this.postContent,
      this.timestamp, this.photo, this.tags, this.user);

  factory ForumPost.fromJson(Map<String, dynamic> json) =>
      _$ForumPostFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ForumPostToJson(this);
}
