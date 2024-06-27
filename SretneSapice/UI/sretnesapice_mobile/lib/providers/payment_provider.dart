import 'dart:convert';

import 'package:sretnesapice_mobile/models/payment.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class PaymentProvider extends BaseProvider<Payment> {
  PaymentProvider() : super("Payments");

  @override
  Payment fromJson(data) {
    return Payment.fromJson(data);
  }

   Future<String> initiatePayment(int orderId) async {
    var url = "$totalUrl/initiate-payment?orderId=$orderId";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('paypalUrl') && data['paypalUrl'] is String) {
        return data['paypalUrl'] as String;
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Failed to initiate payment: ${response.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>> verifyPayment(String token) async {
    var url = "$totalUrl/success?token=$token";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http!.post(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Error verifying payment");
    }
  }
}