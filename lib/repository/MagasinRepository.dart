

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Magasin.dart';
import 'package:cs/single/constant.dart';

class MagasinRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Magasin>>>  getAll() => get('/magasins',decoder: (obj) => Magasin.listFromJson(obj),headers: headeConst);

  Future<Response<Magasin>>  getOne(int id) => get('/magasins/$id',decoder: (obj) => Magasin.fromJson(obj),headers: headeConst);

  Future<Response<Magasin>> createMagasin(Magasin magasin)  => post('/magasins', magasin.toJson(),decoder: (obj) => Magasin.fromJson(obj),headers: headeConst);

  Future<Response<Magasin>> updateMagasin(Magasin magasin) => put('/magasins/${magasin.id}', magasin.toJson(),decoder: (obj) => Magasin.fromJson(obj),headers: headeConst);

  Future<Response> deleteMagasin(int id) => delete('/magasins/$id',headers: headeConst);
}