import 'package:json_annotation/json_annotation.dart';

part 'service_insert_request.g.dart';

@JsonSerializable()
class ServiceInsertRequest {
  int? dogWalkerId;
  int? userId;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? date;
  String? status;
  String? dogBreed;

  ServiceInsertRequest() {}

  factory ServiceInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceInsertRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ServiceInsertRequestToJson(this);
}
