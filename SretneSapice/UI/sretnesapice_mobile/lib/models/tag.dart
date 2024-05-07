import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  int? tagId;
  String? tagName;

  Tag(this.tagId, this.tagName);

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TagToJson(this);
}
