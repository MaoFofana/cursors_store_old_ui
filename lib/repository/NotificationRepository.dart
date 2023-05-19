import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Notification.dart';
import 'package:cs/single/constant.dart';

class NotificationRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Notification>>>  getAll() => get('/notifications',decoder: (obj) => Notification.listFromJson(obj), headers: headeConst);

  Future<Response<Notification>>  getOne(int id) => get('/notifications/$id',decoder: (obj) => Notification.fromJson(obj), headers: headeConst);

  Future<Response<Notification>> createNotification(Notification notification)  => post('/notifications', notification.toJson(),decoder: (obj) => Notification.fromJson(obj), headers: headeConst);

  Future<Response<Notification>> updateNotification(Notification notification) => put('/notifications/${notification.id}', notification.toJson(),decoder: (obj) => Notification.fromJson(obj), headers: headeConst);

  Future<Response> deleteNotification(int id) => delete('/notifications/$id', headers: headeConst);
}