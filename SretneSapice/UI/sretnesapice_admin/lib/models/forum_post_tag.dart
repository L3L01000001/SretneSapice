import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_admin/models/forum_post.dart';
import 'package:sretnesapice_admin/models/tag.dart';

part 'forum_post_tag.g.dart';

@JsonSerializable()
class ForumPostTag {
  int? postsPostId;
  int? tagsTagId;
  Tag? tag;
  ForumPost? forumPost;

  ForumPostTag(this.postsPostId, this.tagsTagId, this.tag, this.forumPost);

  factory ForumPostTag.fromJson(Map<String, dynamic> json) =>
      _$ForumPostTagFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ForumPostTagToJson(this);
}
