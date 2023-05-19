
import 'package:cs/model/Magasin.dart';

import 'Order.dart';
import 'PanierProduct.dart';
import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User{
  int? id;
  String? email;
  String? password;
  String? name;
  String? code;
  String? code_link;
  String? role;
  String? firebase;
  @JsonKey(ignore: true)
  bool? active;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  String? phone;
  String? adresse;
  @JsonKey(name: 'remember_me_token')
  String? rememberMeToken;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  List<Order>? orders;
  @JsonKey(name: 'paniers_products')
  List<PanierProduct>? paniersProducts;
  @JsonKey(name: 'order_livreurs')
  List<Order>? orderLivreurs;
  List<Magasin>? magasins;
  Magasin? magasin_gerer;

  User();


  User.name(
      this.id,
      this.email,
      this.password,
      this.name,
      this.code,
      this.role,
      this.active,
      this.avatarUrl,
      this.phone,
      this.adresse,
      this.rememberMeToken,
      this.createdAt,
      this.updatedAt,
      this.orders,
      this.paniersProducts);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  static List<User> listFromJson(list) =>
      List<User>.from(list.map((x) => User.fromJson(x)));
}