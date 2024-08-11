import 'package:json_annotation/json_annotation.dart';

part 'requests_by_status.g.dart';

@JsonSerializable()
class RequestsByStatus {
  String? status;
  int? count;

  RequestsByStatus(this.status, this.count);

  factory RequestsByStatus.fromJson(Map<String, dynamic> json) =>
      _$RequestsByStatusFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RequestsByStatusToJson(this);
}
