

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Unite.dart';
import 'package:cs/single/constant.dart';

class UniteRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Unite>>>  getAll() => get('/unites',decoder: (obj) => Unite.listFromJson(obj), headers: headeConst);

  Future<Response<Unite>>  getOne(int id) => get('/unites/$id',decoder: (obj) => Unite.fromJson(obj), headers: headeConst);

  Future<Response<Unite>> createUnite(Unite unite)  => post('/unites', unite.toJson(),decoder: (obj) => Unite.fromJson(obj), headers: headeConst);

  Future<Response<Unite>> updateUnite(Unite unite) => put('/unites/${unite.id}', unite.toJson(),decoder: (obj) => Unite.fromJson(obj), headers: headeConst);

  Future<Response> deleteUnite(int id) => delete('/unites/$id', headers: headeConst);
}