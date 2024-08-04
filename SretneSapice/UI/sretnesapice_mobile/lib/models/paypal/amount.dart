import 'package:json_annotation/json_annotation.dart';
import 'package:sretnesapice_mobile/models/paypal/details.dart';

part 'amount.g.dart';

@JsonSerializable()
class Amount {
  double total;
  String currency;
  Details details;

  Amount(this.total, this.currency, this.details);

  factory Amount.fromJson(Map<String, dynamic> json) => _$AmountFromJson(json);

  Map<String, dynamic> toJson() => _$AmountToJson(this);
}
