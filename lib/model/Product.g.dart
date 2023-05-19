// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..id = json['id'] as int?
  ..code = json['code'] as String?
  ..name = json['name'] as String?
  ..unite = json['unite'] as String?
  ..sluk = json['sluk'] as String?
  ..quantity = json['quantity'] as int?
  ..seuil = json['seuil'] as int?
  ..description = json['description'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..salePrice = (json['sale_price'] as num?)?.toDouble()
  ..reduction = (json['reduction'] as num?)?.toDouble()
  ..active = json['active'] as bool?
  ..weight = (json['weight'] as num?)?.toDouble()
  ..categorieId = json['categorie_id'] as int?
  ..categorie = json['categorie'] == null
      ? null
      : Categorie.fromJson(json['categorie'] as Map<String, dynamic>)
  ..images = (json['images'] as List<dynamic>?)
      ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
      .toList()
  ..panierProducts = (json['panier_products'] as List<dynamic>?)
      ?.map((e) => PanierProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String)
  ..stocks = (json['stocks'] as List<dynamic>?)
      ?.map((e) => Stock.fromJson(e as Map<String, dynamic>))
      .toList()
  ..magasinId = json['magasin_id'] as int?
  ..magasin = json['magasin'] == null
      ? null
      : Magasin.fromJson(json['magasin'] as Map<String, dynamic>);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'unite': instance.unite,
      'sluk': instance.sluk,
      'quantity': instance.quantity,
      'seuil': instance.seuil,
      'description': instance.description,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'reduction': instance.reduction,
      'active': instance.active,
      'weight': instance.weight,
      'categorie_id': instance.categorieId,
      'categorie': instance.categorie,
      'images': instance.images,
      'panier_products': instance.panierProducts,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'stocks': instance.stocks,
      'magasin_id': instance.magasinId,
      'magasin': instance.magasin,
    };
