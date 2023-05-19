

import 'package:cs/model/NotifVersion.dart';
import 'package:get/get.dart';
import 'package:cs/single/constant.dart';

class NotificationVersionRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<NotifVersion>>>  getAll() => get('/notif_versions',decoder: (obj) => NotifVersion.listFromJson(obj),headers: headeConst);

  Future<Response<NotifVersion>>  getOne(int id) => get('/notif_versions/$id',decoder: (obj) => NotifVersion.fromJson(obj),headers: headeConst);

  Future<Response<NotifVersion>>  getLastVersion() => get('/notif_versions/get/last',decoder: (obj) => NotifVersion.fromJson(obj),headers: headeConst);


  Future<Response<NotifVersion>> createMagasin(NotifVersion item)  => post('/notif_versions', item.toJson(),decoder: (obj) => NotifVersion.fromJson(obj),headers: headeConst);

  Future<Response<NotifVersion>> updateMagasin(NotifVersion item) => put('/notif_versions/${item.id}', item.toJson(),decoder: (obj) => NotifVersion.fromJson(obj),headers: headeConst);

  Future<Response> deleteMagasin(int id) => delete('/notif_versions/$id',headers: headeConst);
}