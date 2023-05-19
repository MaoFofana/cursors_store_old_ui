// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order()
  ..id = json['id'] as int?
  ..number = json['number'] as String?
  ..status = json['status'] as String?
  ..avance = (json['avance'] as num?)?.toDouble()
  ..reste = (json['reste'] as num?)?.toDouble()
  ..lieu = json['lieu'] as String?
  ..clientName = json['client_name'] as String?
  ..clientNumber = json['client_number'] as String?
  ..discountTotal = (json['discount_total'] as num?)?.toDouble()
  ..shippingTotal = (json['shipping_total'] as num?)?.toDouble()
  ..total = (json['total'] as num?)?.toDouble()
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String)
  ..panierProducts = (json['panier_products'] as List<dynamic>?)
      ?.map((e) => PanierProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..userId = json['user_id'] as int?
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..livreurId = json['livreur_id'] as int?
  ..livreur = json['livreur'] == null
      ? null
      : User.fromJson(json['livreur'] as Map<String, dynamic>);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'status': instance.status,
      'avance': instance.avance,
      'reste': instance.reste,
      'lieu': instance.lieu,
      'client_name': instance.clientName,
      'client_number': instance.clientNumber,
      'discount_total': instance.discountTotal,
      'shipping_total': instance.shippingTotal,
      'total': instance.total,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'panier_products': instance.panierProducts,
      'user_id': instance.userId,
      'user': instance.user,
      'livreur_id': instance.livreurId,
      'livreur': instance.livreur,
    };
