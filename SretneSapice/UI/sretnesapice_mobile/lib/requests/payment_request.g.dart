// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest()
      ..orderId = (json['orderId'] as num?)?.toInt()
      ..paymentMethod = json['paymentMethod'] as String?
      ..transactionId = json['transactionId'] as String?
      ..status = json['status'] as String?
      ..amount = (json['amount'] as num?)?.toDouble();

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'paymentMethod': instance.paymentMethod,
      'transactionId': instance.transactionId,
      'status': instance.status,
      'amount': instance.amount,
    };
