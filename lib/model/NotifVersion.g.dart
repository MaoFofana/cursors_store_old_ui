// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotifVersion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifVersion _$NotifVersionFromJson(Map<String, dynamic> json) => NotifVersion()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..message = json['message'] as String?
  ..version = json['version'] as String?
  ..feature = json['feature'] as String?
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$NotifVersionToJson(NotifVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'version': instance.version,
      'feature': instance.feature,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
