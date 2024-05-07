// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      (json['cityID'] as num?)?.toInt(),
      json['name'] as String?,
      (json['countryId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'cityID': instance.cityID,
      'name': instance.name,
      'countryId': instance.countryId,
    };
