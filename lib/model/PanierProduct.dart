
import 'Order.dart';
import 'Product.dart';
import 'User.dart';

import 'package:json_annotation/json_annotation.dart';
part 'PanierProduct.g.dart';

@JsonSerializable()
class PanierProduct {
  int? id;
  int? quantite;
  double? price;
  String? name;
  String? image;
  @JsonKey(name: 'order_id')
  int? orderId;
  Order? order;
  @JsonKey(name: 'product_id')
  int? productId;
  @JsonKey(name: 'user_id')
  int? userId;
  User? user;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  PanierProduct();

  factory PanierProduct.fromJson(Map<String, dynamic> json) => _$PanierProductFromJson(json);
  Map<String, dynamic> toJson() => _$PanierProductToJson(this);

  static List<PanierProduct> listFromJson(list) =>
      List<PanierProduct>.from(list.map((x) => PanierProduct.fromJson(x)));

}