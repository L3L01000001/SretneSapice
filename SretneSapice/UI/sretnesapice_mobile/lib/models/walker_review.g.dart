// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walker_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkerReview _$WalkerReviewFromJson(Map<String, dynamic> json) => WalkerReview(
      (json['reviewId'] as num?)?.toInt(),
      (json['dogWalkerId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      (json['rating'] as num?)?.toInt(),
      json['reviewText'] as String?,
      json['timestamp'] as String?,
      json['dogWalker'] == null
          ? null
          : DogWalker.fromJson(json['dogWalker'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalkerReviewToJson(WalkerReview instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'dogWalkerId': instance.dogWalkerId,
      'userId': instance.userId,
      'rating': instance.rating,
      'reviewText': instance.reviewText,
      'timestamp': instance.timestamp,
      'dogWalker': instance.dogWalker,
      'user': instance.user,
    };
