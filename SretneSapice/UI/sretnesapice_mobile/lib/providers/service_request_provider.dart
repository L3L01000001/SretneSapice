import 'dart:convert';

import 'package:sretnesapice_mobile/models/service_request.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class ServiceRequestProvider extends BaseProvider<ServiceRequest> {
  ServiceRequestProvider() : super("ServiceRequests");

  @override
  ServiceRequest fromJson(data) {
    return ServiceRequest.fromJson(data);
  }

  Future<List<ServiceRequest>> getServiceRequestsByWalkerId(
      int dogWalkerId) async {
    var url = "$totalUrl/serviceRequests/$dogWalkerId";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);

      return data['result']
          .map((x) => fromJson(x))
          .cast<ServiceRequest>()
          .toList();
    } else {
      throw Exception("Greška!");
    }
  }

  Future<List<ServiceRequest>> getServiceRequestsByLoggedInUser() async {
    var url = "$totalUrl/serviceRequestsByLoggedInUser";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result']
          .map((x) => fromJson(x))
          .cast<ServiceRequest>()
          .toList();
    } else {
      throw Exception("Greška!");
    }
  }

  Future<void> acceptServiceRequest(int serviceRequestId) async {
    var url = "$totalUrl/$serviceRequestId/accept";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    try {
      var response = await http!.put(uri, headers: headers);
      if (response.statusCode == 200) {
        print("Zahtjev za uslugu prihvacen.");
      } else {
        throw Exception(
            "Error finishing service request! Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error finishing service request! Exception: $e");
    }
  }

  Future<void> rejectServiceRequest(int serviceRequestId) async {
    var url = "$totalUrl/$serviceRequestId/reject";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    try {
      var response = await http!.put(uri, headers: headers);
      if (response.statusCode == 200) {
        print("Usluga odbijena.");
      } else {
        throw Exception(
            "Error finishing service request! Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error finishing service request! Exception: $e");
    }
  }

  Future<void> finishServiceRequest(int serviceRequestId) async {
    var url = "$totalUrl/$serviceRequestId/markAsFinished";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    try {
      var response = await http!.put(uri, headers: headers);
      if (response.statusCode == 200) {
        print("Usluga završena.");
      } else {
        throw Exception(
            "Error finishing service request! Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error finishing service request! Exception: $e");
    }
  }
}
