import 'package:get/get.dart';
import 'package:cs/single/constant.dart';

class AuthenficationRepository extends GetConnect{
  @override
  void onInit() {
  }
  Future<Response> authentication(String phone)  => get('$baseUrlConst/authentication/$phone');
  Future<Response> authenticationQr(String phone, String code)  => get('$baseUrlConst/authentication/qr/$phone/$code');
  Future<Response> register(Map data)  => post('$baseUrlConst/register', data);
  Future<Response> login(Map data)  => post('$baseUrlConst/login', data, contentType: "application/json; charset=UTF-8");
}
