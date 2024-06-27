import 'dart:convert';

import 'package:sretnesapice_mobile/models/dog_walker_availability.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class AvailabilityProvider extends BaseProvider<DogWalkerAvailability> {
  AvailabilityProvider() : super("DogWalkerAvailabilities");

  @override
  DogWalkerAvailability fromJson(data) {
    return DogWalkerAvailability.fromJson(data);
  }

  Future<List<DogWalkerAvailability>> getAvailabilitiesByWalkerId(int dogWalkerId) async {
    var url = "$totalUrl/getAvailabilityStatusForDogWalker/$dogWalkerId";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      
      var data = jsonDecode(response.body);

      return data['result'].map((x) => fromJson(x)).cast<DogWalkerAvailability>().toList();
    } else {
      throw Exception("Greška!");
    }
  }
}
