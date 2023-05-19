// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PanierProduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanierProduct _$PanierProductFromJson(Map<String, dynamic> json) =>
    PanierProduct()
      ..id = json['id'] as int?
      ..quantite = json['quantite'] as int?
      ..price = (json['price'] as num?)?.toDouble()
      ..name = json['name'] as String?
      ..image = json['image'] as String?
      ..orderId = json['order_id'] as int?
      ..order = json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>)
      ..productId = json['product_id'] as int?
      ..userId = json['user_id'] as int?
      ..user = json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>)
      ..createdAt = json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String)
      ..updatedAt = json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String);

Map<String, dynamic> _$PanierProductToJson(PanierProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantite': instance.quantite,
      'price': instance.price,
      'name': instance.name,
      'image': instance.image,
      'order_id': instance.orderId,
      'order': instance.order,
      'product_id': instance.productId,
      'user_id': instance.userId,
      'user': instance.user,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
