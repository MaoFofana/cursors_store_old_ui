




import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cs/model/FraisLivraison.dart';
import 'package:cs/single/constant.dart';

class FraisLivraisonRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrlConst;
  }

  Future<Response<List<FraisLivraison>>>  getAll() => get('$baseUrlConst/frais_livraisons',decoder: (obj) => FraisLivraison.listFromJson(obj), headers: headeConst);

  Future<Response<FraisLivraison>>  getOne(int id) => get('$baseUrlConst/frais_livraisons/$id',decoder: (obj) => FraisLivraison.fromJson(obj), headers: headeConst);

  Future<Response<FraisLivraison>> createFraisLivraison(FraisLivraison frais_livraison)  => post('$baseUrlConst/frais_livraisons', frais_livraison.toJson(),decoder: (obj) => FraisLivraison.fromJson(obj), headers: headeConst);

  Future<Response<FraisLivraison>> updateFraisLivraison(FraisLivraison frais_livraison) => put('$baseUrlConst/frais_livraisons/${frais_livraison.id}', frais_livraison.toJson(),decoder: (obj) => FraisLivraison.fromJson(obj), headers: headeConst);

  Future<Response> deleteFraisLivraison(int id) => delete('$baseUrlConst/frais_livraisons/$id', headers: headeConst);
}