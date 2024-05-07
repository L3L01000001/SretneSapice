import 'package:sretnesapice_mobile/models/order.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super("Orders");

  @override 
  Order fromJson(data){
    return Order.fromJson(data);
  }
}