import 'dart:convert';

import 'package:sretnesapice_mobile/models/payment.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class PaymentProvider extends BaseProvider<Payment> {
  PaymentProvider() : super("Payments");

  @override
  Payment fromJson(data) {
    return Payment.fromJson(data);
  }

  Future<void> updateTransactionId(int orderId, String transactionId) async {
    var url = "$totalUrl/update-transaction-id";

    var uri = Uri.parse(url);

    var requestBody = jsonEncode({
      'orderId': orderId,
      'transactionId': transactionId,
    });

    Map<String, String> headers = createHeaders();
    var response = await http!.put(uri, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      print("Updateano!");
    } else {
      throw Exception('Greška');
    }
  }

  Future<void> completePayment(int orderId) async {
    var url = "$totalUrl/$orderId/complete";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.put(uri, headers: headers);

    if (response.statusCode == 200) {
      print("Plaćeno!");
    } else {
      throw Exception('Greška');
    }
  }

  Future<void> cancelPayment(int orderId) async {
    var url = "$totalUrl/$orderId/cancel";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.put(uri, headers: headers);

    if (response.statusCode == 200) {
      print("Otkazano plaćanje!");
    } else {
      throw Exception('Greška');
    }
  }

  Future<int> paymentWithOrderIdExists(int orderId) async {
    var url = "$totalUrl/paymentWithOrderIdExists/$orderId";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = json.decode(response.body);

      return data as int;
    } else {
      throw Exception('Failed to load status');
    }
  }
}
