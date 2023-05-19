// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) => Stock()
  ..id = json['id'] as int?
  ..quantityEntree = json['quantity_entree'] as int?
  ..quantitySortie = json['quantity_sortie'] as int?
  ..quantite = json['quantite'] as int?
  ..prix = (json['prix'] as num?)?.toDouble()
  ..productId = json['product_id'] as int?
  ..product = json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>)
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'id': instance.id,
      'quantity_entree': instance.quantityEntree,
      'quantity_sortie': instance.quantitySortie,
      'quantite': instance.quantite,
      'prix': instance.prix,
      'product_id': instance.productId,
      'product': instance.product,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
