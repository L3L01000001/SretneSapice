import 'package:json_annotation/json_annotation.dart';

part 'user_shipping_info_request.g.dart';

@JsonSerializable()
class UserShippingInfoRequest {
  String? address;
  String? city;
  String? zipcode;
  String? phone;

  UserShippingInfoRequest() {}

  factory UserShippingInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UserShippingInfoRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserShippingInfoRequestToJson(this);
}
