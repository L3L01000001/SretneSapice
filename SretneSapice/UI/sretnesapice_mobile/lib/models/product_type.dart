import 'package:json_annotation/json_annotation.dart';

part 'product_type.g.dart';

@JsonSerializable()
class ProductType {
  int? productTypeId;
  String? productTypeName;

  ProductType(this.productTypeId, this.productTypeName);

    /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ProductType.fromJson(Map<String, dynamic> json) =>
      _$ProductTypeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);
}
