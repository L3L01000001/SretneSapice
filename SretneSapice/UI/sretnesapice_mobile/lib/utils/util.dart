import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sretnesapice_mobile/models/role.dart';
import 'package:sretnesapice_mobile/models/user.dart';

class Authorization {
  static String? username;
  static String? password;
  static int? userId;
  static User? user;
  static Role? role;
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }

  return f.format(dynamic);
}

String formatDate(dynamic) {
  var d = DateFormat('dd.MM.yyyy');

  if(dynamic == null){
    return "";
  }

  return d.format(dynamic);
}

String formatDateTime(dynamic) {
  var d = DateFormat('dd.MM.yyyy HH:mm');
  
  return d.format(dynamic);
}
