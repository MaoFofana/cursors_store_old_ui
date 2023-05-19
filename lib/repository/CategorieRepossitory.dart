

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Categorie.dart';
import 'package:cs/single/constant.dart';

class CategorieRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Categorie>>>  getAll() => get('/categories',decoder: (obj) => Categorie.listFromJson(obj), headers: headeConst);

  Future<Response<Categorie>>  getOne(int id) => get('/categories/$id',decoder: (obj) => Categorie.fromJson(obj), headers: headeConst);

  Future<Response<Categorie>> createCategorie(Categorie categorie)  => post('/categories', categorie.toJson(),decoder: (obj) => Categorie.fromJson(obj), headers: headeConst);

  Future<Response<Categorie>> updateCategorie(Categorie categorie) => put('/categories/${categorie.id}', categorie.toJson(),decoder: (obj) => Categorie.fromJson(obj), headers: headeConst);

  Future<Response> deleteCategorie(int id) => delete('/categories/$id', headers: headeConst);
}