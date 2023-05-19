import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/Image.dart';
import 'package:cs/single/constant.dart';

class ImageRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<Image>>>  getAll() => get('/images',decoder: (obj) => Image.listFromJson(obj), headers: headeConst);

  Future<Response<Image>>  getOne(int id) => get('/images/$id', headers: headeConst);

  Future<Response<Image>> createImage(Image image)  => post('/images', image.toJson(),decoder: (obj) => Image.fromJson(obj), headers: headeConst);

  Future<Response<Image>> updateImage(Image image) => put('/images/${image.id}', image.toJson(),decoder: (obj) => Image.fromJson(obj), headers: headeConst);

  Future<Response> deleteImage(int id) => delete('/images/$id', headers: headeConst);
}