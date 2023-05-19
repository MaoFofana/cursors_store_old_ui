

import 'dart:convert';

import 'package:get/get.dart';
import 'package:cs/single/constant.dart';

class FileRepository extends GetConnect{

  Future<Response> save(List<int> image) {
    return post('$baseUrlConst/upload/encode', {"image" : base64Encode(image)});
  }


}
