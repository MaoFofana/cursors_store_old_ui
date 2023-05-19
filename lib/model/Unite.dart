


import 'package:json_annotation/json_annotation.dart';

part 'Unite.g.dart';

@JsonSerializable()
class Unite {
  int? id;
  String? name;

  Unite();
  factory Unite.fromJson(Map<String, dynamic> json) => _$UniteFromJson(json);
  Map<String, dynamic> toJson() => _$UniteToJson(this);
  static List<Unite> listFromJson(list) =>
      List<Unite>.from(list.map((x) => Unite.fromJson(x)));
}