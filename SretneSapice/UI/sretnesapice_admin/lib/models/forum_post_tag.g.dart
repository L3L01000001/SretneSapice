// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPostTag _$ForumPostTagFromJson(Map<String, dynamic> json) => ForumPostTag(
      json['postsPostId'] as int?,
      json['tagsTagId'] as int?,
      json['tag'] == null
          ? null
          : Tag.fromJson(json['tag'] as Map<String, dynamic>),
      json['forumPost'] == null
          ? null
          : ForumPost.fromJson(json['forumPost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForumPostTagToJson(ForumPostTag instance) =>
    <String, dynamic>{
      'postsPostId': instance.postsPostId,
      'tagsTagId': instance.tagsTagId,
      'tag': instance.tag,
      'forumPost': instance.forumPost,
    };
