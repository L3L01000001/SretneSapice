// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests_by_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestsByStatus _$RequestsByStatusFromJson(Map<String, dynamic> json) =>
    RequestsByStatus(
      json['status'] as String?,
      json['count'] as int?,
    );

Map<String, dynamic> _$RequestsByStatusToJson(RequestsByStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'count': instance.count,
    };
