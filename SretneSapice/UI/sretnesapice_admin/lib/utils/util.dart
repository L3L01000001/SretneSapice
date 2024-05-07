import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sretnesapice_admin/models/role.dart';
import 'package:sretnesapice_admin/models/user.dart';

class Authorization {
  static String? username;
  static String? password;
  static User? user;
  static Role? role;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image));
}

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');

  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

String formatDate(dynamic) {
  var d = DateFormat('dd.MM.yyyy HH:mm');

  if(dynamic == null){
    return "";
  }

  return d.format(dynamic);
}
