// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) => UserRole(
      json['userRoleId'] as int?,
      json['userId'] as int?,
      json['roleId'] as int?,
      json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'userRoleId': instance.userRoleId,
      'userId': instance.userId,
      'roleId': instance.roleId,
      'role': instance.role,
    };
