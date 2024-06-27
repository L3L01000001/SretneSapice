// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_shipping_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserShippingInfoRequest _$UserShippingInfoRequestFromJson(
        Map<String, dynamic> json) =>
    UserShippingInfoRequest()
      ..address = json['address'] as String?
      ..city = json['city'] as String?
      ..zipcode = json['zipcode'] as String?
      ..phone = json['phone'] as String?;

Map<String, dynamic> _$UserShippingInfoRequestToJson(
        UserShippingInfoRequest instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'zipcode': instance.zipcode,
      'phone': instance.phone,
    };
