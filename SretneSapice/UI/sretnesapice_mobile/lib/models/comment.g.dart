// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      (json['commentId'] as num?)?.toInt(),
      (json['postId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['commentContent'] as String?,
      json['timestamp'] as String?,
      (json['likesCount'] as num?)?.toInt(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      (json['commentLikes'] as List<dynamic>)
          .map((e) => CommentLike.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'commentId': instance.commentId,
      'postId': instance.postId,
      'userId': instance.userId,
      'commentContent': instance.commentContent,
      'timestamp': instance.timestamp,
      'likesCount': instance.likesCount,
      'user': instance.user,
      'commentLikes': instance.commentLikes,
    };
