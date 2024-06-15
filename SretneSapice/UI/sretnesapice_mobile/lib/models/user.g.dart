// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['userId'] as num).toInt(),
      json['name'] as String?,
      json['surname'] as String?,
      json['fullName'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['username'] as String?,
      json['password'] as String?,
      json['confirmPassword'] as String?,
      (json['userRoles'] as List<dynamic>)
          .map((e) => UserRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['cityID'] as num?)?.toInt(),
      json['profilePhoto'] as String?,
      json['status'] as bool?,
      json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'surname': instance.surname,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'userRoles': instance.userRoles,
      'cityID': instance.cityID,
      'profilePhoto': instance.profilePhoto,
      'status': instance.status,
      'city': instance.city,
    };
