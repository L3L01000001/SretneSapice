// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateRequest _$UserUpdateRequestFromJson(Map<String, dynamic> json) =>
    UserUpdateRequest()
      ..name = json['name'] as String?
      ..surname = json['surname'] as String?
      ..email = json['email'] as String?
      ..phone = json['phone'] as String?
      ..username = json['username'] as String?
      ..cityID = (json['cityID'] as num?)?.toInt()
      ..profilePhoto = json['profilePhoto'] as String?
      ..status = json['status'] as bool?;

Map<String, dynamic> _$UserUpdateRequestToJson(UserUpdateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'cityID': instance.cityID,
      'profilePhoto': instance.profilePhoto,
      'status': instance.status,
    };
