// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_4924.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDo4924 _$ToDo4924FromJson(Map<String, dynamic> json) => ToDo4924(
      (json['toDoId'] as num?)?.toInt(),
      json['nazivAktivnosti'] as String?,
      json['opisAktivnosti'] as String?,
      json['datumIzvrsenja'] == null
          ? null
          : DateTime.parse(json['datumIzvrsenja'] as String),
      json['statusAktivnosti'] as String?,
      (json['userId'] as num?)?.toInt(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ToDo4924ToJson(ToDo4924 instance) => <String, dynamic>{
      'toDoId': instance.toDoId,
      'nazivAktivnosti': instance.nazivAktivnosti,
      'opisAktivnosti': instance.opisAktivnosti,
      'datumIzvrsenja': instance.datumIzvrsenja?.toIso8601String(),
      'statusAktivnosti': instance.statusAktivnosti,
      'userId': instance.userId,
      'user': instance.user,
    };
