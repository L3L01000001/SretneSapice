import 'package:json_annotation/json_annotation.dart';

part 'order_item_update_request.g.dart';

@JsonSerializable()
class OrderItemUpdateRequest {
  int? quantity;

  OrderItemUpdateRequest() {}

  factory OrderItemUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderItemUpdateRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$OrderItemUpdateRequestToJson(this);
}
