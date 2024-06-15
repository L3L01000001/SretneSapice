import 'dart:convert';

import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class DogWalkerProvider extends BaseProvider<DogWalker> {
  DogWalkerProvider() : super("DogWalkers");

  Future<List<DogWalker>> getDogWalkersWithMostReviewsFirst() async {
    var url = "$totalUrl/getDogWalkersWithMostReviewsFirst";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<DogWalker>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

  Future<List<DogWalker>> getDogWalkersWithMostFinishedServicesFirst() async {
    var url = "$totalUrl/getDogWalkersWithMostFinishedServicesFirst";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data['result'].map((x) => fromJson(x)).cast<DogWalker>().toList();
    } else {
      throw Exception("Greška!");
    }
  }

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

  @override
  DogWalker fromJson(data) {
    return DogWalker.fromJson(data);
  }
}
