// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRequest _$ServiceRequestFromJson(Map<String, dynamic> json) =>
    ServiceRequest(
      json['serviceRequestId'] as int?,
      json['dogWalkerId'] as int?,
      json['userId'] as int?,
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['status'] as String?,
      json['dogBreed'] as String?,
      json['liveLocationEnabled'] as bool?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['dogWalker'] == null
          ? null
          : DogWalker.fromJson(json['dogWalker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServiceRequestToJson(ServiceRequest instance) =>
    <String, dynamic>{
      'serviceRequestId': instance.serviceRequestId,
      'dogWalkerId': instance.dogWalkerId,
      'userId': instance.userId,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'status': instance.status,
      'dogBreed': instance.dogBreed,
      'liveLocationEnabled': instance.liveLocationEnabled,
      'user': instance.user,
      'dogWalker': instance.dogWalker,
    };
