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

    var headers = createHeaders();
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

    var headers = createHeaders();
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
}
