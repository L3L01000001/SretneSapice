import 'package:sretnesapice_admin/models/order.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super("Orders");

  @override 
  Order fromJson(data){
    return Order.fromJson(data);
  }
}