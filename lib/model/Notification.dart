


import 'User.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Notification.g.dart';

@JsonSerializable()
class Notification {
  int? id;
  String? title;
  String? message;
  bool? lu;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'user_id')
  int? userId;
  User? user;


  Notification();
  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
  static List<Notification> listFromJson(list) =>
      List<Notification>.from(list.map((x) => Notification.fromJson(x)));
}