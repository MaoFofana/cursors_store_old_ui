
import 'package:cs/single/constant.dart';

import 'package:get/get.dart';

import '../model/Dashboard.dart';



class DashboardRepository extends GetConnect {


  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }


  Future<Response<Dashboard>>  getByPeriode(String start, String end) =>
      get('/dashboard/$start/$end',decoder: (obj) =>Dashboard.fromJson(obj), headers: headeConst);

}