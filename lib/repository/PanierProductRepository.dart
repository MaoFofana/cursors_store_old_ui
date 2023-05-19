

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/PanierProduct.dart';
import 'package:cs/single/constant.dart';

class PanierProductRepository extends GetConnect {
  @override
  void onInit() {
    //httpClient.defaultDecoder = PanierProduct.fromJson as Decoder;
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<PanierProduct>>>  getAll() => get('/panier_products',decoder: (obj) => PanierProduct.listFromJson(obj), headers: headeConst);

  Future<Response<PanierProduct>>  getOne(int id) => get('/panier_products/$id',decoder: (obj) => PanierProduct.fromJson(obj), headers: headeConst);

  Future<Response<PanierProduct>> createPanierProduct(PanierProduct panier_product)  => post('/panier_products', panier_product.toJson(),decoder: (obj) => PanierProduct.fromJson(obj), headers: headeConst);

  Future<Response<PanierProduct>> updatePanierProduct(PanierProduct panier_product) => put('/panier_products/${panier_product.id}', panier_product.toJson(),decoder: (obj) => PanierProduct.fromJson(obj), headers: headeConst);

  Future<Response> deletePanierProduct(int id) => delete('/panier_products/$id', headers: headeConst);
}