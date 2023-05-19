// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FraisLivraison.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FraisLivraison _$FraisLivraisonFromJson(Map<String, dynamic> json) =>
    FraisLivraison()
      ..id = json['id'] as int?
      ..lieu = json['lieu'] as String?
      ..min = (json['min'] as num?)?.toDouble()
      ..max = (json['max'] as num?)?.toDouble()
      ..price = (json['price'] as num?)?.toDouble()
      ..status = json['status'] as bool?
      ..createdAt = json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String)
      ..updatedAt = json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$FraisLivraisonToJson(FraisLivraison instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lieu': instance.lieu,
      'min': instance.min,
      'max': instance.max,
      'price': instance.price,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
