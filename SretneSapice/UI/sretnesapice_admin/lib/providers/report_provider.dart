import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sretnesapice_admin/models/report.dart';
import 'package:sretnesapice_admin/models/requests_by_status.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

class ReportProvider extends BaseProvider<Report> {
  ReportProvider() : super("Reports");

  @override
  Report fromJson(data) {
    return Report.fromJson(data);
  }

  Future<int> getTotalRequests({dynamic filter}) async {
    var url = "$totalUrl/total";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return data as int;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<List<RequestsByStatus>> getStatusBreakdown({dynamic filter}) async {
    var url = "$totalUrl/status-breakdown";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return data
          .map((x) => RequestsByStatus.fromJson(x))
          .cast<RequestsByStatus>()
          .toList();
    } else {
      throw new Exception("Unknown error");
    }
  }
}