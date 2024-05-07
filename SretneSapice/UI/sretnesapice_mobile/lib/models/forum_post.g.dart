// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumPost _$ForumPostFromJson(Map<String, dynamic> json) => ForumPost(
      (json['postId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['title'] as String?,
      json['postContent'] as String?,
      json['timestamp'] as String?,
      json['photo'] as String?,
      (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForumPostToJson(ForumPost instance) => <String, dynamic>{
      'postId': instance.postId,
      'userId': instance.userId,
      'title': instance.title,
      'postContent': instance.postContent,
      'timestamp': instance.timestamp,
      'photo': instance.photo,
      'tags': instance.tags,
      'user': instance.user,
    };
