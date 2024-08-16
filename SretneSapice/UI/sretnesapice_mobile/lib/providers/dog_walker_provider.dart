import 'dart:convert';

import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class DogWalkerProvider extends BaseProvider<DogWalker> {
  DogWalkerProvider() : super("DogWalkers");

  Future<bool> checkDogWalkerApplicationStatus(int userId) async {
    var url = "$totalUrl/hasUserAppliedToBeDogWalker/$userId";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = json.decode(response.body);

      return data as bool;
    } else {
      throw Exception('Failed to load status');
    }
  }

  Future<String> getDogWalkerStatusByUserId(int userId) async {
    var url = "$totalUrl/getDogWalkerStatusByUserId/$userId";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = json.decode(response.body);

      return data['result'] as String;
    } else {
      throw Exception('Failed to load status');
    }
  }

  Future<int> getDogWalkerIdByUserId(int userId) async {
    var url = "$totalUrl/getDogWalkerIdByUserId/$userId";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = json.decode(response.body);

      return data as int;
    } else {
      throw Exception('Failed to load dog walker id');
    }
  }

  @override
  DogWalker fromJson(data) {
    return DogWalker.fromJson(data);
  }
}
