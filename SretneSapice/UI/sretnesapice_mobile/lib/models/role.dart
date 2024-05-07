import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  int? roleID;
  String? name;

  Role(this.roleID, this.name);

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
