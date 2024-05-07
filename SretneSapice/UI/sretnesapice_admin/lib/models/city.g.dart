// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      json['cityID'] as int?,
      json['name'] as String?,
      json['countryId'] as int?,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'cityID': instance.cityID,
      'name': instance.name,
      'countryId': instance.countryId,
    };
