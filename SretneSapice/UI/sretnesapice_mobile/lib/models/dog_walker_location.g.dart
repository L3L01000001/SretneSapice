// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_walker_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogWalkerLocation _$DogWalkerLocationFromJson(Map<String, dynamic> json) =>
    DogWalkerLocation(
      (json['dogWalkerId'] as num?)?.toInt(),
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      (json['latitude'] as num?)?.toDouble(),
      (json['longitude'] as num?)?.toDouble(),
      json['dogWalker'] == null
          ? null
          : DogWalker.fromJson(json['dogWalker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DogWalkerLocationToJson(DogWalkerLocation instance) =>
    <String, dynamic>{
      'dogWalkerId': instance.dogWalkerId,
      'timestamp': instance.timestamp?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'dogWalker': instance.dogWalker,
    };
