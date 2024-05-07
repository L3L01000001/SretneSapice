import 'package:sretnesapice_admin/models/order_item.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class OrderItemProvider extends BaseProvider<OrderItem> {
  OrderItemProvider() : super("OrderItems");

  @override
  OrderItem fromJson(data) {
    return OrderItem.fromJson(data);
  }
}
