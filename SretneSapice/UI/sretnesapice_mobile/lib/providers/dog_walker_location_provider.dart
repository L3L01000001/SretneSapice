import 'dart:convert';

import 'package:sretnesapice_mobile/models/dog_walker_location.dart';
import 'package:sretnesapice_mobile/providers/base_provider.dart';

class DogWalkerLocationProvider extends BaseProvider<DogWalkerLocation> {
  DogWalkerLocationProvider() : super("DogWalkerLocations");

  @override 
  DogWalkerLocation fromJson(data){
    return DogWalkerLocation.fromJson(data);
  }

   Future<bool> dogWalkerExistsInTable(int dogWalkerId) async {
    var url = "$totalUrl/dogWalkerExistsInTable/$dogWalkerId";

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
}