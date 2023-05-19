// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as int?
  ..email = json['email'] as String?
  ..password = json['password'] as String?
  ..name = json['name'] as String?
  ..code = json['code'] as String?
  ..code_link = json['code_link'] as String?
  ..role = json['role'] as String?
  ..firebase = json['firebase'] as String?
  ..avatarUrl = json['avatar_url'] as String?
  ..phone = json['phone'] as String?
  ..adresse = json['adresse'] as String?
  ..rememberMeToken = json['remember_me_token'] as String?
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..updatedAt = json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String)
  ..orders = (json['orders'] as List<dynamic>?)
      ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
      .toList()
  ..paniersProducts = (json['paniers_products'] as List<dynamic>?)
      ?.map((e) => PanierProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..orderLivreurs = (json['order_livreurs'] as List<dynamic>?)
      ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
      .toList()
  ..magasins = (json['magasins'] as List<dynamic>?)
      ?.map((e) => Magasin.fromJson(e as Map<String, dynamic>))
      .toList()
  ..magasin_gerer = json['magasin_gerer'] == null
      ? null
      : Magasin.fromJson(json['magasin_gerer'] as Map<String, dynamic>);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'code': instance.code,
      'code_link': instance.code_link,
      'role': instance.role,
      'firebase': instance.firebase,
      'avatar_url': instance.avatarUrl,
      'phone': instance.phone,
      'adresse': instance.adresse,
      'remember_me_token': instance.rememberMeToken,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'orders': instance.orders,
      'paniers_products': instance.paniersProducts,
      'order_livreurs': instance.orderLivreurs,
      'magasins': instance.magasins,
      'magasin_gerer': instance.magasin_gerer,
    };
