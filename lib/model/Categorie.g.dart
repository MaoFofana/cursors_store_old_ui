// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Categorie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categorie _$CategorieFromJson(Map<String, dynamic> json) => Categorie()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..description = json['description'] as String?
  ..image = json['image'] as String?
  ..categorieId = json['categorie_id'] as int?
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String)
  ..categorie = json['categorie'] == null
      ? null
      : Categorie.fromJson(json['categorie'] as Map<String, dynamic>)
  ..magasinId = json['magasin_id'] as int?
  ..magasin = json['magasin'] == null
      ? null
      : Magasin.fromJson(json['magasin'] as Map<String, dynamic>)
  ..categories = (json['categories'] as List<dynamic>?)
      ?.map((e) => Categorie.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CategorieToJson(Categorie instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'categorie_id': instance.categorieId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'categorie': instance.categorie,
      'magasin_id': instance.magasinId,
      'magasin': instance.magasin,
      'categories': instance.categories,
      'products': instance.products,
    };
