

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/single/constant.dart';

class ProductRepository extends GetConnect {

  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Product>>>  getAll() => get('/products',decoder: (obj) => Product.listFromJson(obj),headers: headeConst);

  Future<Response<List<Product>>>  getByCategorie(String id) => get('/categorie-product/$id',decoder: (obj) => Product.listFromJson(obj),headers: headeConst);

  Future<Response<List<Product>>>  getByMagasin(String id) => get('/magasin-product/$id',decoder: (obj) => Product.listFromJson(obj),headers: headeConst);

  Future<Response<List<Product>>>  search(String search) => get('/search/product/$search',decoder: (obj) => Product.listFromJson(obj),headers: headeConst);


  Future<Response<List<Product>>>  getByMagasinAndCategorie(String idMagasin, String idCategorie) => get('/magasin-categorie-product/$idMagasin/$idCategorie',decoder: (obj) => Product.listFromJson(obj),headers: headeConst);

  Future<Response<Product>>  getOne(int id) => get('/products/$id',decoder: (obj) => Product.fromJson(obj),headers: headeConst);

  Future<Response<Product>> createProduct(Product product)  => post('/products', product.toJson(),decoder: (obj) => Product.fromJson(obj),headers: headeConst);

  Future<Response<Product>> updateProduct(Product product) => put('/products/${product.id}', product.toJson(),decoder: (obj) => Product.fromJson(obj),headers: headeConst);

  Future<Response> deleteProduct(int id) => delete('/products/$id',headers: headeConst);
}