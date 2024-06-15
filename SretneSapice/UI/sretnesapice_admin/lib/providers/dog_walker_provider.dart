import 'dart:convert';

import 'package:sretnesapice_admin/models/dog_walker.dart';
import 'package:sretnesapice_admin/providers/base_provider.dart';

import 'package:http/http.dart' as http;

class DogWalkerProvider extends BaseProvider<DogWalker> {
  DogWalkerProvider() : super("DogWalkers");

  @override
  DogWalker fromJson(data) {
    return DogWalker.fromJson(data);
  }

  Future<DogWalker> approve(int dogWalkerId) async {
    var url = "$totalUrl/$dogWalkerId/approve";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    
    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      DogWalker user = fromJson(data) as DogWalker;
      return user;
    } else {
      throw Exception('Failed to approve dog walker');
    }
  }

  Future<DogWalker> reject(int dogWalkerId) async {
    var url = "$totalUrl/$dogWalkerId/reject";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    
    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      DogWalker user = fromJson(data) as DogWalker;
      return user;
    } else {
      throw Exception('Failed to reject dog walker');
    }
  }
}
