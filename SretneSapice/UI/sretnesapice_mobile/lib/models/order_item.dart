import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/product.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  int? orderItemId;
  int? orderId;
  int? productId;
  int? quantity;
  double? subtotal;
  Product? product;

  OrderItem(this.orderItemId, this.orderId, this.productId, this.quantity,
      this.subtotal, this.product);

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
