


import 'Magasin.dart';
import 'Product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Categorie.g.dart';

@JsonSerializable()
class Categorie {
  int? id;
  String? name;
  String? description;
  String? image;
  @JsonKey(name: 'categorie_id')
  int? categorieId;

  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  Categorie? categorie;
  @JsonKey(name: 'magasin_id')
  int? magasinId;
  Magasin? magasin;
  List<Categorie>? categories;
  List<Product>? products;

  Categorie();

  factory Categorie.fromJson(Map<String, dynamic> json) => _$CategorieFromJson(json);
  Map<String, dynamic> toJson() => _$CategorieToJson(this);
  static List<Categorie> listFromJson(list) =>
      List<Categorie>.from(list.map((x) => Categorie.fromJson(x)));
}