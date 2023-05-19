// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dashboard _$DashboardFromJson(Map<String, dynamic> json) => Dashboard(
      json['ajouter'] as int,
      json['sortie'] as int,
      json['commande'] as int,
      json['in_stock'] as int,
      json['commande_total'] as int,
    );

Map<String, dynamic> _$DashboardToJson(Dashboard instance) => <String, dynamic>{
      'ajouter': instance.ajouter,
      'sortie': instance.sortie,
      'commande': instance.commande,
      'in_stock': instance.inStock,
      'commande_total': instance.commandeTotal,
    };
