import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Order.dart';
import 'package:cs/single/constant.dart';

class OrderRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Order>>>  getAll() => get('/orders',decoder: (obj) => Order.listFromJson(obj),headers: headeConst);

  Future<Response<List<Order>>>  getMyOrders() => get('/orders/users/me',decoder: (obj) => Order.listFromJson(obj),headers: headeConst);

  Future<Response<List<Order>>>  byDeliverer(int id) => get('/orders/deliverer/$id',decoder: (obj) => Order.listFromJson(obj),headers: headeConst);


  Future<Response<Order>>  getOne(int id) => get('/orders/$id',decoder: (obj) => Order.fromJson(obj), headers: headeConst);

  Future<Response<Order>> createOrder(Order order)  => post('/orders', order.toJson(),decoder: (obj) => Order.fromJson(obj), headers: headeConst);

  Future<Response<Order>> updateOrder(Order order) => put('/orders/${order.id}', order.toJson(),decoder: (obj) => Order.fromJson(obj), headers: headeConst);

  Future<Response> deleteOrder(int id) => delete('/orders/$id', headers: headeConst);
}