

import 'package:get/get.dart';
import 'package:cs/model/User.dart';
import 'package:cs/single/constant.dart';
class UserRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<User>>>  getAll() => get('/users',decoder: (obj) => User.listFromJson(obj), headers: headeConst);
  Future<Response<List<User>>>  getByRole(String role) => get('/users/role/$role',decoder: (obj) => User.listFromJson(obj), headers: headeConst);
  Future<Response<List<User>>>  getEntrepriseUser(int id) => get('/users/patrons/$id',decoder: (obj) => User.listFromJson(obj), headers: headeConst);
  Future<Response<User>>  getOne(int id) => get('/users/$id',decoder: (obj) => User.fromJson(obj), headers: headeConst);

  Future<Response<User>> createUser(User user)  => post('/users', user.toJson(),decoder: (obj) => User.fromJson(obj), headers: headeConst);
  Future<Response<User>> affecterUser(Map user)  => post('/users/magasins', user,decoder: (obj) => User.fromJson(obj), headers: headeConst);
  Future<Response<User>> updateUser(User user) => put('/users/${user.id}', user.toJson(),decoder: (obj) => User.fromJson(obj), headers: headeConst);
  Future<Response> sendCoteEmail(String email) => get('/users/password-code-send/$email');

  Future<Response> deleteUser(int id) => delete('/users/$id');
}