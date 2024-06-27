import 'package:json_annotation/json_annotation.dart';

part 'order_item_request.g.dart';

@JsonSerializable()
class OrderItemRequest {
  int? orderId;
  int? productId;
  int? quantity;
  double? subtotal;

  OrderItemRequest() {}

  factory OrderItemRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderItemRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$OrderItemRequestToJson(this);
}
