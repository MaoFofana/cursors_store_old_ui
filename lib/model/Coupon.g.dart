// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coupon _$CouponFromJson(Map<String, dynamic> json) => Coupon()
  ..id = json['id'] as int?
  ..code = json['code'] as String?
  ..reduction = (json['reduction'] as num?)?.toDouble()
  ..start =
      json['start'] == null ? null : DateTime.parse(json['start'] as String)
  ..end = json['end'] == null ? null : DateTime.parse(json['end'] as String)
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'reduction': instance.reduction,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
