// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Panier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Panier _$PanierFromJson(Map<String, dynamic> json) => Panier(
      json['quantite'] as int,
      Product.fromJson(json['produit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PanierToJson(Panier instance) => <String, dynamic>{
      'quantite': instance.quantite,
      'produit': instance.produit,
    };
