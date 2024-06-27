// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      (json['paymentId'] as num?)?.toInt(),
      (json['orderId'] as num?)?.toInt(),
      json['paymentMethod'] as String?,
      json['transactionMethod'] as String?,
      json['status'] as String?,
      (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'paymentId': instance.paymentId,
      'orderId': instance.orderId,
      'paymentMethod': instance.paymentMethod,
      'transactionMethod': instance.transactionMethod,
      'status': instance.status,
      'amount': instance.amount,
    };
