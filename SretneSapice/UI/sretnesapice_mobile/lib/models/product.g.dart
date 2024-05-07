// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      (json['productID'] as num?)?.toInt(),
      json['name'] as String?,
      json['description'] as String?,
      json['code'] as String?,
      (json['price'] as num?)?.toDouble(),
      json['productPhoto'] as String?,
      (json['stockQuantity'] as num?)?.toInt(),
      (json['productTypeID'] as num?)?.toInt(),
      json['brand'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'productID': instance.productID,
      'name': instance.name,
      'description': instance.description,
      'code': instance.code,
      'price': instance.price,
      'productPhoto': instance.productPhoto,
      'stockQuantity': instance.stockQuantity,
      'productTypeID': instance.productTypeID,
      'brand': instance.brand,
    };
