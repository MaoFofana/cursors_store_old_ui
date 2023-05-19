

import 'package:json_annotation/json_annotation.dart';

part 'FraisLivraison.g.dart';

@JsonSerializable()
class FraisLivraison{
  int? id;
  String? lieu;
  double? min;
  double? max;
  double? price;
  bool? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  FraisLivraison();
  factory FraisLivraison.fromJson(Map<String, dynamic> json) => _$FraisLivraisonFromJson(json);
  Map<String, dynamic> toJson() => _$FraisLivraisonToJson(this);
  static List<FraisLivraison> listFromJson(list) =>
      List<FraisLivraison>.from(list.map((x) => FraisLivraison.fromJson(x)));
}