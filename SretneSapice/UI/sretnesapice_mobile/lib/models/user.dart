import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/city.dart';
import 'package:sretnesapice_mobile/models/user_role.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? userId;
  String? name;
  String? surname;
  String? fullName;
  String? email;
  String? phone;
  String? username;
  String? password;
  String? confirmPassword;
  List<UserRole> userRoles;
  int? cityID;
  String? profilePhoto;
  bool? status;
  City? city;

  User(
      this.userId,
      this.name,
      this.surname,
      this.fullName,
      this.email,
      this.phone,
      this.username,
      this.password,
      this.confirmPassword,
      this.userRoles,
      this.cityID,
      this.profilePhoto,
      this.status,
      this.city);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
