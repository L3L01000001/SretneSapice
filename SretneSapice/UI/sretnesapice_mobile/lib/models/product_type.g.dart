// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductType _$ProductTypeFromJson(Map<String, dynamic> json) => ProductType(
      (json['productTypeId'] as num?)?.toInt(),
      json['productTypeName'] as String?,
    );

Map<String, dynamic> _$ProductTypeToJson(ProductType instance) =>
    <String, dynamic>{
      'productTypeId': instance.productTypeId,
      'productTypeName': instance.productTypeName,
    };
