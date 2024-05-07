// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      (json['orderItemId'] as num?)?.toInt(),
      (json['orderId'] as num?)?.toInt(),
      (json['productId'] as num?)?.toInt(),
      (json['quantity'] as num?)?.toInt(),
      (json['subtotal'] as num?)?.toDouble(),
      json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'orderItemId': instance.orderItemId,
      'orderId': instance.orderId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
      'product': instance.product,
    };
