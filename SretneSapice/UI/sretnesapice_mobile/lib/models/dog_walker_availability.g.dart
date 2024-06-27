// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_walker_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogWalkerAvailability _$DogWalkerAvailabilityFromJson(
        Map<String, dynamic> json) =>
    DogWalkerAvailability(
      (json['dogWalkerId'] as num?)?.toInt(),
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      json['availabilityStatus'] as String?,
      json['dogWalker'] == null
          ? null
          : DogWalker.fromJson(json['dogWalker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DogWalkerAvailabilityToJson(
        DogWalkerAvailability instance) =>
    <String, dynamic>{
      'dogWalkerId': instance.dogWalkerId,
      'date': instance.date?.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'availabilityStatus': instance.availabilityStatus,
      'dogWalker': instance.dogWalker,
    };
