import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
part 'Coupon.g.dart';

@JsonSerializable()
class Coupon {
  int?  id;
  String? code;
  double? reduction;
  DateTime? start;
  DateTime? end;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  Coupon();
  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  Map<String, dynamic> toJson() => _$CouponToJson(this);
  static List<Coupon> listFromJson(list) =>
      List<Coupon>.from(list.map((x) => Coupon.fromJson(x)));
}