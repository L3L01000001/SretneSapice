// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceInsertRequest _$ServiceInsertRequestFromJson(
        Map<String, dynamic> json) =>
    ServiceInsertRequest()
      ..dogWalkerId = (json['dogWalkerId'] as num?)?.toInt()
      ..userId = (json['userId'] as num?)?.toInt()
      ..startTime = json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String)
      ..endTime = json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String)
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..status = json['status'] as String?
      ..dogBreed = json['dogBreed'] as String?;

Map<String, dynamic> _$ServiceInsertRequestToJson(
        ServiceInsertRequest instance) =>
    <String, dynamic>{
      'dogWalkerId': instance.dogWalkerId,
      'userId': instance.userId,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'status': instance.status,
      'dogBreed': instance.dogBreed,
    };
