// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRequest _$ServiceRequestFromJson(Map<String, dynamic> json) =>
    ServiceRequest(
      (json['serviceRequestId'] as num?)?.toInt(),
      (json['dogWalkerId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      json['date'] as String?,
      json['status'] as String?,
      json['dogBreed'] as String?,
      json['liveLocationEnabled'] as bool?,
    );

Map<String, dynamic> _$ServiceRequestToJson(ServiceRequest instance) =>
    <String, dynamic>{
      'serviceRequestId': instance.serviceRequestId,
      'dogWalkerId': instance.dogWalkerId,
      'userId': instance.userId,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'date': instance.date,
      'status': instance.status,
      'dogBreed': instance.dogBreed,
      'liveLocationEnabled': instance.liveLocationEnabled,
    };
