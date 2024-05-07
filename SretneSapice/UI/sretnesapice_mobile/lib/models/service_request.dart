import 'package:json_annotation/json_annotation.dart';

part 'service_request.g.dart';

@JsonSerializable()
class ServiceRequest {
  int? serviceRequestId;
  int? dogWalkerId;
  int? userId;
  DateTime? startTime;
  DateTime? endTime;
  String? date;
  String? status;
  String? dogBreed;
  bool? liveLocationEnabled;

  ServiceRequest(
      this.serviceRequestId,
      this.dogWalkerId,
      this.userId,
      this.startTime,
      this.endTime,
      this.date,
      this.status,
      this.dogBreed,
      this.liveLocationEnabled);

  factory ServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ServiceRequestToJson(this);
}
