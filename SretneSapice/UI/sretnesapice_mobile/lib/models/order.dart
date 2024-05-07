import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int? orderId;
  String? orderNumber;
  int? userId;
  int? shippingInfoId;
  String? date;
  String? status;
  double? totalAmount;
  User? user;

  Order(this.orderId, this.orderNumber, this.userId, this.shippingInfoId,
      this.date, this.status, this.totalAmount, this.user);

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
