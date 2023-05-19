// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Magasin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Magasin _$MagasinFromJson(Map<String, dynamic> json) => Magasin()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..principale = json['principale'] as bool?
  ..description = json['description'] as String?
  ..adresse = json['adresse'] as String?
  ..image = json['image'] as String?
  ..userId = json['user_id'] as int?
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String)
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..categories = (json['categories'] as List<dynamic>?)
      ?.map((e) => Categorie.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList()
  ..gerantId = json['gerant_id'] as int?
  ..gerant = json['gerant'] == null
      ? null
      : User.fromJson(json['gerant'] as Map<String, dynamic>);

Map<String, dynamic> _$MagasinToJson(Magasin instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'principale': instance.principale,
      'description': instance.description,
      'adresse': instance.adresse,
      'image': instance.image,
      'user_id': instance.userId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'user': instance.user,
      'categories': instance.categories,
      'products': instance.products,
      'gerant_id': instance.gerantId,
      'gerant': instance.gerant,
    };
