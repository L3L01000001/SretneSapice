// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      json['orderId'] as int?,
      json['orderNumber'] as String?,
      json['userId'] as int?,
      json['shippingInfoId'] as int?,
      DateTime.parse(json['date'] as String),
      json['status'] as String?,
      (json['totalAmount'] as num?)?.toDouble(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'orderNumber': instance.orderNumber,
      'userId': instance.userId,
      'shippingInfoId': instance.shippingInfoId,
      'date': instance.date.toIso8601String(),
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'user': instance.user,
    };
