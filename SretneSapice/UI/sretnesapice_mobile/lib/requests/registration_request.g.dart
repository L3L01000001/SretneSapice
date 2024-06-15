// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) =>
    RegistrationRequest()
      ..name = json['name'] as String?
      ..surname = json['surname'] as String?
      ..email = json['email'] as String?
      ..phone = json['phone'] as String?
      ..username = json['username'] as String?
      ..password = json['password'] as String?
      ..confirmPassword = json['confirmPassword'] as String?
      ..cityID = (json['cityID'] as num?)?.toInt();

Map<String, dynamic> _$RegistrationRequestToJson(
        RegistrationRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'cityID': instance.cityID,
    };
