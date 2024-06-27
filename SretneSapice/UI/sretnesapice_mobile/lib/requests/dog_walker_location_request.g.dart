// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_walker_location_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogWalkerLocationRequest _$DogWalkerLocationRequestFromJson(
        Map<String, dynamic> json) =>
    DogWalkerLocationRequest()
      ..dogWalkerId = (json['dogWalkerId'] as num?)?.toInt()
      ..timestamp = json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String)
      ..latitude = (json['latitude'] as num?)?.toDouble()
      ..longitude = (json['longitude'] as num?)?.toDouble()
      ..dogWalker = json['dogWalker'] == null
          ? null
          : DogWalker.fromJson(json['dogWalker'] as Map<String, dynamic>);

Map<String, dynamic> _$DogWalkerLocationRequestToJson(
        DogWalkerLocationRequest instance) =>
    <String, dynamic>{
      'dogWalkerId': instance.dogWalkerId,
      'timestamp': instance.timestamp?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'dogWalker': instance.dogWalker,
    };
