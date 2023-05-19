



import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Coupon.dart';
import 'package:cs/single/constant.dart';

class CouponRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Coupon>>>  getAll() => get('/coupons',decoder: (obj) => Coupon.listFromJson(obj), headers: headeConst);

  Future<Response<Coupon>>  getOne(int id) => get('/coupons/$id',decoder: (obj) => Coupon.fromJson(obj), headers: headeConst);

  Future<Response<Coupon>> createCoupon(Coupon coupon)  => post('/coupons', coupon.toJson(),decoder: (obj) => Coupon.fromJson(obj), headers: headeConst);

  Future<Response<Coupon>> updateCoupon(Coupon coupon) => put('/coupons/${coupon.id}', coupon.toJson(),decoder: (obj) => Coupon.fromJson(obj), headers: headeConst);

  Future<Response> deleteCoupon(int id) => delete('/coupons/$id', headers: headeConst);
}