// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemRequest _$OrderItemRequestFromJson(Map<String, dynamic> json) =>
    OrderItemRequest()
      ..orderId = (json['orderId'] as num?)?.toInt()
      ..productId = (json['productId'] as num?)?.toInt()
      ..quantity = (json['quantity'] as num?)?.toInt()
      ..subtotal = (json['subtotal'] as num?)?.toDouble();

Map<String, dynamic> _$OrderItemRequestToJson(OrderItemRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
    };
