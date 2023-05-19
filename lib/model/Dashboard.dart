import 'package:json_annotation/json_annotation.dart';

part 'Dashboard.g.dart';

@JsonSerializable()
class Dashboard {
  int ajouter;
  int sortie;
  int commande;
  @JsonKey(name: "in_stock")
  int inStock;
  @JsonKey(name: "commande_total")
  int commandeTotal;
  Dashboard(this.ajouter, this.sortie, this.commande, this.inStock, this.commandeTotal);
  factory Dashboard.fromJson(Map<String, dynamic> json) => _$DashboardFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardToJson(this);

}
