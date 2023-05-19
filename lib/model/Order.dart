

import 'PanierProduct.dart';
import 'User.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Order.g.dart';

@JsonSerializable()
class Order {
  int? id;
  String? number ;
  String? status;
  double? avance;
  double? reste;
  String? lieu;
  @JsonKey(name: 'client_name')
  String?  clientName;
  @JsonKey(name: 'client_number')
  String?  clientNumber;
  @JsonKey(name: 'discount_total')
  double? discountTotal;
  @JsonKey(name: 'shipping_total')
  double? shippingTotal ;
  double? total;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'panier_products')
  List<PanierProduct>? panierProducts;
  @JsonKey(name: 'user_id')
  int?  userId;
  User? user ;
  @JsonKey(name: 'livreur_id')
  int?  livreurId;
  User? livreur ;

  Order();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
  static List<Order> listFromJson(list) =>
      List<Order>.from(list.map((x) => Order.fromJson(x)));
}