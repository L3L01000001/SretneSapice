import 'dart:convert';

import 'package:sretnesapice_admin/providers/base_provider.dart';
import 'package:sretnesapice_admin/models/user.dart';

import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("Users");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<User> Authenticate({dynamic filter}) async {
    var url = "$totalUrl/Authenticate";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      User user = fromJson(data) as User;
      return user;
    } else {
      throw Exception("Pogrešno korisničko ime ili lozinka");
    }
  }
}
