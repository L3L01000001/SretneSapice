// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentLike _$CommentLikeFromJson(Map<String, dynamic> json) => CommentLike(
      (json['likeId'] as num?)?.toInt(),
      (json['commentId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['timestamp'] as String?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['comment'] == null
          ? null
          : Comment.fromJson(json['comment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentLikeToJson(CommentLike instance) =>
    <String, dynamic>{
      'likeId': instance.likeId,
      'commentId': instance.commentId,
      'userId': instance.userId,
      'timestamp': instance.timestamp,
      'user': instance.user,
      'comment': instance.comment,
    };
