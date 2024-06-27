// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemUpdateRequest _$OrderItemUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    OrderItemUpdateRequest()..quantity = (json['quantity'] as num?)?.toInt();

Map<String, dynamic> _$OrderItemUpdateRequestToJson(
        OrderItemUpdateRequest instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
    };
