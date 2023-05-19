import 'User.dart';
import 'package:json_annotation/json_annotation.dart';
part 'NotifVersion.g.dart';

@JsonSerializable()
class NotifVersion {
  int? id;
  String? title;
  String? message;
  String? version;
  String? feature;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  NotifVersion();
  factory NotifVersion.fromJson(Map<String, dynamic> json) => _$NotifVersionFromJson(json);
  Map<String, dynamic> toJson() => _$NotifVersionToJson(this);

  static List<NotifVersion> listFromJson(list) =>
      List<NotifVersion>.from(list.map((x) => NotifVersion.fromJson(x)));
}