import 'package:sretnesapice_mobile/models/order.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super("Orders");

  @override 
  Order fromJson(data){
    return Order.fromJson(data);
  }

  Future<void> paidOrder(int orderId) async {
    var url = "$totalUrl/$orderId/paid-order";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.put(uri, headers: headers);

    if (response.statusCode == 200) {
      print("Narudžba završena!");
    } else {
      throw Exception('Greška');
    }
  }

  Future<void> cancelOrder(int orderId) async {
    var url = "$totalUrl/$orderId/cancel-order";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.put(uri, headers: headers);

    if (response.statusCode == 200) {
      print("Narudžba otkazana!");
    } else {
      throw Exception('Greška');
    }
  }
}