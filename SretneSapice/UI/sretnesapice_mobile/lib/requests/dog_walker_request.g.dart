// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_walker_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogWalkerRequest _$DogWalkerRequestFromJson(Map<String, dynamic> json) =>
    DogWalkerRequest()
      ..name = json['name'] as String?
      ..surname = json['surname'] as String?
      ..age = (json['age'] as num?)?.toInt()
      ..phone = json['phone'] as String?
      ..cityID = (json['cityID'] as num?)?.toInt()
      ..experience = json['experience'] as String?
      ..profilePhoto = json['profilePhoto'] as String?;

Map<String, dynamic> _$DogWalkerRequestToJson(DogWalkerRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'age': instance.age,
      'phone': instance.phone,
      'cityID': instance.cityID,
      'experience': instance.experience,
      'profilePhoto': instance.profilePhoto,
    };
