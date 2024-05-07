import 'dart:convert';

import 'package:sretnesapice_mobile/providers/base_provider.dart';
import 'package:sretnesapice_mobile/models/user.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("Users");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<User> Authenticate() async {
    var url = "$totalUrl/Authenticate";

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      User user = fromJson(data) as User;
      return user;
    } else {
      throw Exception("Pogrešno korisničko ime ili lozinka");
    }
  }
}
