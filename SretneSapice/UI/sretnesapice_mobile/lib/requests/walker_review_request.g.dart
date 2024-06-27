// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walker_review_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkerReviewRequest _$WalkerReviewRequestFromJson(Map<String, dynamic> json) =>
    WalkerReviewRequest()
      ..dogWalkerId = (json['dogWalkerId'] as num?)?.toInt()
      ..reviewText = json['reviewText'] as String?
      ..rating = (json['rating'] as num?)?.toInt();

Map<String, dynamic> _$WalkerReviewRequestToJson(
        WalkerReviewRequest instance) =>
    <String, dynamic>{
      'dogWalkerId': instance.dogWalkerId,
      'reviewText': instance.reviewText,
      'rating': instance.rating,
    };
