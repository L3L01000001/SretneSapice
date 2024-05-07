import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/order.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'user_shipping_information.g.dart';

@JsonSerializable()
class UserShippingInformation {
  int? shippingInfoId;
  int? userId;
  String? address;
  String? city;
  String? zipcode;
  String? phone;
  List<Order>? orders;
  User? user;

  UserShippingInformation(this.shippingInfoId, this.userId, this.address,
      this.city, this.zipcode, this.phone, this.orders, this.user);

  factory UserShippingInformation.fromJson(Map<String, dynamic> json) =>
      _$UserShippingInformationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserShippingInformationToJson(this);
}
