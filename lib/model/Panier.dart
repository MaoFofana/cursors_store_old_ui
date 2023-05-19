import 'package:json_annotation/json_annotation.dart';
import 'package:cs/model/Product.dart';

part 'Panier.g.dart';

@JsonSerializable()
class Panier {
  int quantite ;
  Product produit;
  Panier(this.quantite,this.produit);

  factory Panier.fromJson(Map<String, dynamic> json) => _$PanierFromJson(json);
  Map<String, dynamic> toJson() => _$PanierToJson(this);
  static List<Panier> listFromJson(list) =>
      List<Panier>.from(list.map((x) => Panier.fromJson(x)));
}