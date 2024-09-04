import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'to_do_4924.g.dart';

@JsonSerializable()
class ToDo4924 {
  int? toDoId;
  String? nazivAktivnosti;
  String? opisAktivnosti;
  DateTime? datumIzvrsenja;
  String? statusAktivnosti;
  int? userId;
  User? user;

  ToDo4924(this.toDoId, this.nazivAktivnosti, this.opisAktivnosti,
      this.datumIzvrsenja, this.statusAktivnosti, this.userId, this.user);

  factory ToDo4924.fromJson(Map<String, dynamic> json) =>
      _$ToDo4924FromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ToDo4924ToJson(this);
}
