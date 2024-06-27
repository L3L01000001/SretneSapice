// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      (json['orderId'] as num?)?.toInt(),
      json['orderNumber'] as String?,
      (json['userId'] as num?)?.toInt(),
      (json['shippingInfoId'] as num?)?.toInt(),
      json['date'] as String?,
      json['status'] as String?,
      (json['totalAmount'] as num?)?.toDouble(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'orderNumber': instance.orderNumber,
      'userId': instance.userId,
      'shippingInfoId': instance.shippingInfoId,
      'date': instance.date,
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'user': instance.user,
      'orderItems': instance.orderItems,
    };
