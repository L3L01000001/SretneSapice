import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/dog_walker.dart';
import 'package:sretnesapice_mobile/models/user.dart';

part 'service_request.g.dart';

@JsonSerializable()
class ServiceRequest {
  int? serviceRequestId;
  int? dogWalkerId;
  int? userId;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? date;
  String? status;
  String? dogBreed;
  bool? liveLocationEnabled;
  User? user;
  DogWalker? dogWalker;

  ServiceRequest(
      this.serviceRequestId,
      this.dogWalkerId,
      this.userId,
      this.startTime,
      this.endTime,
      this.date,
      this.status,
      this.dogBreed,
      this.liveLocationEnabled,
      this.user,
      this.dogWalker);

  factory ServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ServiceRequestToJson(this);
}
