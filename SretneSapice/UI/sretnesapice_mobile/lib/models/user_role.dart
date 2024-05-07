import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/role.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  int? userRoleId;
  int? userId;
  int? roleId;
  Role? role;

  UserRole(this.userRoleId, this.userId, this.roleId, this.role);

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
