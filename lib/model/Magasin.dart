import 'package:cs/model/User.dart';

import 'Categorie.dart';
import 'Product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Magasin.g.dart';

@JsonSerializable()
class Magasin {
  int? id;
  String? name;
  bool? principale;
  String? description;
  String? adresse;
  String? image;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  User? user;
  List<Categorie>? categories;
  List<Product>? products;
  @JsonKey(name: 'gerant_id')
  int? gerantId;
  User? gerant;


  Magasin();

  factory Magasin.fromJson(Map<String, dynamic> json) => _$MagasinFromJson(json);
  Map<String, dynamic> toJson() => _$MagasinToJson(this);
  static List<Magasin> listFromJson(list) =>
      List<Magasin>.from(list.map((x) => Magasin.fromJson(x)));
}