// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_walker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteWalker _$FavoriteWalkerFromJson(Map<String, dynamic> json) =>
    FavoriteWalker(
      (json['favoriteWalkerId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      (json['dogWalkerId'] as num?)?.toInt(),
      json['dogWalker'] == null
          ? null
          : DogWalker.fromJson(json['dogWalker'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteWalkerToJson(FavoriteWalker instance) =>
    <String, dynamic>{
      'favoriteWalkerId': instance.favoriteWalkerId,
      'userId': instance.userId,
      'dogWalkerId': instance.dogWalkerId,
      'user': instance.user,
      'dogWalker': instance.dogWalker,
    };
