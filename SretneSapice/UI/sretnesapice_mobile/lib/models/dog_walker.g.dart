// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_walker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogWalker _$DogWalkerFromJson(Map<String, dynamic> json) => DogWalker(
      (json['dogWalkerId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['name'] as String?,
      json['surname'] as String?,
      (json['age'] as num?)?.toInt(),
      (json['cityId'] as num?)?.toInt(),
      json['phone'] as String?,
      json['experience'] as String?,
      json['dogWalkerPhoto'] as String?,
      (json['rating'] as num?)?.toInt(),
      json['isApproved'] as bool?,
      json['status'] as String?,
    );

Map<String, dynamic> _$DogWalkerToJson(DogWalker instance) => <String, dynamic>{
      'dogWalkerId': instance.dogWalkerId,
      'userId': instance.userId,
      'name': instance.name,
      'surname': instance.surname,
      'age': instance.age,
      'cityId': instance.cityId,
      'phone': instance.phone,
      'experience': instance.experience,
      'dogWalkerPhoto': instance.dogWalkerPhoto,
      'rating': instance.rating,
      'isApproved': instance.isApproved,
      'status': instance.status,
    };
