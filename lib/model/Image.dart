


import 'Product.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Image.g.dart';

@JsonSerializable()
class Image {
  int? id;
  String? url;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'product_id')
  int? productId;
  Product? product;

  Image();

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
  static List<Image> listFromJson(list) =>
      List<Image>.from(list.map((x) => Image.fromJson(x)));
}
