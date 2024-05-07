// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_shipping_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserShippingInformation _$UserShippingInformationFromJson(
        Map<String, dynamic> json) =>
    UserShippingInformation(
      (json['shippingInfoId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['address'] as String?,
      json['city'] as String?,
      json['zipcode'] as String?,
      json['phone'] as String?,
      (json['orders'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserShippingInformationToJson(
        UserShippingInformation instance) =>
    <String, dynamic>{
      'shippingInfoId': instance.shippingInfoId,
      'userId': instance.userId,
      'address': instance.address,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'phone': instance.phone,
      'orders': instance.orders,
      'user': instance.user,
    };
