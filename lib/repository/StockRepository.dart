

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Stock.dart';
import 'package:cs/single/constant.dart';

class StockRepository extends GetConnect {


  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Stock>>>  getAll() => get('/stocks',decoder: (obj){
    return Stock.listFromJson(obj);
  },headers: headeConst);

  Future<Response<List<Stock>>>  getByPeriode(String start, String end) =>
      get('/stocks/periodes/$start/$end',decoder: (obj) =>Stock.listFromJson(obj), headers: headeConst);
  Future<Response<List<Stock>>>  getByPeriodeAndProduct(String start, String end, int id) =>
      get('/stocks/periodes/product/$start/$end/$id',decoder: (obj){
       return  Stock.listFromJson(obj);
      }, headers: headeConst
      );

  Future<Response<Stock>>  getOne(int id) => get('/stocks/$id',decoder: (obj) => Stock.fromJson(obj), headers: headeConst);

  Future<Response<Stock>> createStock(Stock stock)  => post('/stocks', stock.toJson(),decoder: (obj) => Stock.fromJson(obj), headers: headeConst);

  Future<Response<Stock>> updateStock(Stock stock) => put('/stocks/${stock.id}', stock.toJson(),decoder: (obj) => Stock.fromJson(obj), headers: headeConst);

  Future<Response> deleteStock(int id) => delete('/stocks/$id', headers: headeConst);
}