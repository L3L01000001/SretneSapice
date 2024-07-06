// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['commentId'] as int?,
      json['postId'] as int?,
      json['userId'] as int?,
      json['commentContent'] as String?,
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      json['likesCount'] as int?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'commentId': instance.commentId,
      'postId': instance.postId,
      'userId': instance.userId,
      'commentContent': instance.commentContent,
      'timestamp': instance.timestamp?.toIso8601String(),
      'likesCount': instance.likesCount,
      'user': instance.user,
    };
