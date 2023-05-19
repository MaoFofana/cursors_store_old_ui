



import 'Categorie.dart';
import 'Image.dart';
import 'Magasin.dart';
import 'PanierProduct.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Stock.dart';
part 'Product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String? code;
  String? name;
  String? unite;
  String? sluk;
  int? quantity;
  int? seuil;
  String? description;
  double? price;
  @JsonKey(name: 'sale_price')
  double? salePrice;
  double? reduction;
  bool? active;
  double? weight;
  @JsonKey(name: 'categorie_id')
  int? categorieId;
  Categorie? categorie;
  List<Image>? images;
  @JsonKey(name: 'panier_products')
  List<PanierProduct>? panierProducts;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  List<Stock>? stocks;
  @JsonKey(name: 'magasin_id')
  int? magasinId;
  Magasin? magasin;
  Product();
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
  static List<Product> listFromJson(list) =>
      List<Product>.from(list.map((x) => Product.fromJson(x)));

  Product getValue(json){
    return Product.fromJson(json);
  }

}