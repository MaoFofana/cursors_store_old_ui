

import 'package:cs/model/Product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Stock.g.dart';

@JsonSerializable()
class Stock {
   int? id;
   @JsonKey(name: "quantity_entree")
   int? quantityEntree;
   @JsonKey(name: "quantity_sortie")
   int? quantitySortie;
   int? quantite;
   double? prix;
   @JsonKey(name: 'product_id')
   int? productId;
   Product? product;
   @JsonKey(name: 'created_at')
   DateTime? createdAt;
   @JsonKey(name: 'updated_at')
   DateTime? updatedAt;

   Stock();
   factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);
   Map<String, dynamic> toJson() => _$StockToJson(this);
   static List<Stock> listFromJson(list) =>
       List<Stock>.from(list.map((x) => Stock.fromJson(x)));
}
