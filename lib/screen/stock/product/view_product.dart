import 'dart:io';

import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/layouts/dashboard_layout.dart';
import 'package:cs/model/Categorie.dart';
import 'package:cs/model/Magasin.dart';
import 'package:cs/model/Order.dart';
import 'package:cs/model/PanierProduct.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/model/Stock.dart';
import 'package:cs/model/Unite.dart';
import 'package:cs/repository/CategorieRepossitory.dart';
import 'package:cs/repository/FileRepository.dart';
import 'package:cs/repository/ImageRepository.dart';
import 'package:cs/repository/MagasinRepository.dart';
import 'package:cs/repository/OrderRepository.dart';
import 'package:cs/repository/ProductRepository.dart';
import 'package:cs/repository/StockRepository.dart';
import 'package:cs/repository/UniteRepository.dart';
import 'package:cs/screen/menu/profile/components/information_container.dart';
import 'package:cs/screen/stock/rapport/component/rapport_select_modal.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'components/modal_order.dart';

class ViewProduct extends StatefulWidget {
  ViewProduct({super.key, required this.product});
  Product product;
  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  int quantite = 0;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  bool edit = false;
  Product? produit;
  List<String> unites = [];
  List<String> familles = [];
  List<Unite> unitesAll = [];
  List<Categorie> famillesAll = [];
  List<Magasin> magasinsAll = [];
  List<String> magasins = [];
  String? imagePath;
  var uniteRepository = Get.put(UniteRepository());
  var categorieRepository = Get.put(CategorieRepository());
  var produitRepository = Get.put(ProductRepository());
  var magasinRepository = Get.put(MagasinRepository());
  var stockRepository = Get.put(StockRepository());
  int? bottomIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }
  _init() async {
    setState(() {
      produit = widget.product;
    });
    var response = await uniteRepository.getAll();
    if(response.statusCode == 200){
      setState(() {
        unitesAll = response.body!;
        unites = unitesAll.map((e) => e.name!).toList();
      });
    }
    var repsonseFamille = await categorieRepository.getAll();
    if(repsonseFamille.statusCode == 200){
      setState(() {
        famillesAll = repsonseFamille.body!;
        familles = famillesAll.map((e) => e.name!).toList();
      });
    }
    var responseMagasin = await magasinRepository.getAll();
    if(responseMagasin.statusCode == 200){
       magasinsAll = responseMagasin.body!;
       magasins = magasinsAll.map((e) => e.name!).toList();
    }
  }

  Widget get body {
    return Scaffold(
        appBar: AppBar(
         // automaticallyImplyLeading: GetPlatform.isDesktop || GetPlatform.isWeb ? false : true,
          title: Text("Information du produit"),
          centerTitle: true,
          actions: [
           // if(GetPlatform.isMobile)
            IconButton(onPressed: (){
              Get.dialog(RapportSelectModal(product: widget.product,));
            }, icon: Icon(Iconsax.activity))
          ],
        ),
        body: SafeArea(
          child:SingleChildScrollView(
            child:  SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:GetPlatform.isDesktop || GetPlatform.isWeb ?Get.size.width / 5 : 15),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    if(edit == true)
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png'],
                          );
                          if (result != null) {
                            ///File file = File(result.files.single.path!);
                            setState(() {
                              imagePath = result.files.single.path!;
                            });
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          height:150,
                          width: 150,
                          color: Colors.white,
                          child: Center(
                            child: produit!.images  == null && imagePath == null ?
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.transparent,
                              child:Image.asset('assets/images/hamburger.png'),
                            ) :
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 70,
                              child:imagePath == null && produit!.images  != null ?  Image.network("${produit!.images![0].url}", width: 120,height: 120,) :  Image.file(File(imagePath ?? "")),
                            ),
                          ) ,
                        ),
                      ),
                    if(edit == false)
                      Container(
                        width: double.infinity,
                        height: 150,
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.5, color: Colors.black12),
                          ),
                        ),
                        child:  Container(
                          padding: EdgeInsets.all(5),
                          height:120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child:produit?.images != null ? Image.network("${produit?.images![0].url}") : Image.asset('assets/images/avatar.jpg'),
                          ) ,
                        ),
                      ),
                    InformationContainer(label: "Code", information: produit?.code, update: (String code){
                      setState(() {
                        produit?.code = code;
                        produitRepository.updateProduct(produit!);
                      });
                    },active: edit,),
                    InformationContainer(label: "Désignation", information: produit?.name, update: (String value){
                      setState(() {
                        produit?.name = value;
                        produitRepository.updateProduct(produit!);
                      });
                    },active: edit),
                    InformationContainer(label: "Famille", information: produit?.categorie!.name, update: (String value){
                      var categorie =  famillesAll.singleWhere((element) => element.name! == value);
                      setState(() {
                        produit?.categorieId =categorie.id;
                        produit?.categorie = categorie;
                        produitRepository.updateProduct(produit!);
                      });
                    },active: edit, array : familles),
                    InformationContainer(label: "Unité", information: produit?.unite, update: (String value){
                      var unite =  unitesAll.singleWhere((element) => element.name! == value);
                      setState(() {
                        produit?.unite =unite.name;
                        produitRepository.updateProduct(produit!);
                      });
                    },active: edit, array: unites),
                    InformationContainer(label: "Magasin", information: produit?.magasin!.name, update: (String value){
                      var magasin =  magasinsAll.singleWhere((element) => element.name! == value);
                      setState(() {
                        produit?.magasinId =magasin.id;
                        produit?.magasin = magasin;
                        produitRepository.updateProduct(produit!);
                      });
                    },active: edit, array: magasins),
                    InformationContainer(label: "Quantité", information: produit?.quantity.toString(), update: (String value){
                      setState(() {
                        produit?.quantity = int.parse(value);
                        produitRepository.updateProduct(produit!);
                      });
                    },active: false,),
                    InformationContainer(label: "Seuil", information: produit?.seuil != null ? produit?.seuil.toString() : "0", update: (String value){
                      setState(() {
                        produit?.seuil = int.parse(value);
                        produitRepository.updateProduct(produit!);
                      });
                    }, active: edit,type: TextInputType.number,),
                    InformationContainer(
                        label: "Prix", information: "${produit?.price!.toString().replaceAll(".O", "")}F",
                        edit: produit?.price!.toString(),
                        update: (String value){
                          setState(() {
                            produit?.price = double.parse(value);
                            produitRepository.updateProduct(produit!);
                          });
                        },active: edit),
                    InformationContainer(
                        label: "Prix de vente", information: "${produit?.salePrice!.toString().replaceAll(".O", "")}F",
                        edit: produit?.price!.toString(),
                        update: (String value){
                      setState(() {
                        produit?.price = double.parse(value);
                        produitRepository.updateProduct(produit!);
                      });
                    },active: edit),
                    InformationContainer(label: "Réduction", information: "${produit?.reduction!.toString()}%",
                        edit: produit?.reduction!.toString(),
                        update: (String value){
                      setState(() {
                        produit?.reduction = double.parse(value);
                        produitRepository.updateProduct(produit!);
                      });
                    },active: edit,type: TextInputType.number),
                    InformationContainer(label: "Lien", information: "/${userAuth!.code_link!}/${produit!.sluk}", update: (String value){

                    },active: false),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: edit == false ?
        FloatingNavbar(
          width:  GetPlatform.isDesktop || GetPlatform.isWeb ? 800 : double.infinity,
          selectedBackgroundColor:kPrimaryColor,
          selectedItemColor: Colors.white,
          backgroundColor: kPrimaryColor,
          onTap: (int val) async{
            setState(() {
              bottomIndex = val;
            });
            if(val == 3){
              if(imagePath != null){
                var fileRepository = Get.put(FileRepository());
                var imageRepository = Get.put(ImageRepository());
                var imageResponse  =await fileRepository.save(File(imagePath!).readAsBytesSync());
                logger.d(imageResponse.body);
                var image = produit!.images![0];
                image.url  = imageResponse.body["name"];
                var resI = await imageRepository.updateImage(image);
                setState(() {
                  produit!.images![0] = image;
                  imagePath = null;
                });
              }
              setState(() {
                edit = !edit;
              });
            }else if(val == 2){
                launchInBrowser(Uri.parse("https://cursorsdesign.com/product/${userAuth!.code_link!}/${produit!.sluk!}"));
            }else if(val == 1){
              Get.dialog(
                  Dialog(
                      child: ModalOrder(product : produit!)
                  )
              );
            }else {
              Get.dialog(
                  Dialog(
                      child: Container(
                          height: 170,
                          width: GetPlatform.isMobile ? null  : 400,
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text('Approvisionner le stock'),
                              SizedBox(height: 12,),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "Entrer la quantité"
                                ),
                                onChanged: (String value){
                                  setState(() {
                                    quantite = int.parse(value);
                                  });
                                },
                              ),
                              SizedBox(height: 12,),
                              Row(
                                children: [
                                  Expanded(
                                    child: DefaultButton(
                                      color: danger,
                                      text:  "ANULLER", press: (){
                                      setState(() {
                                        quantite = 0;
                                      });
                                      Get.close(1);
                                    },),
                                  ),
                                  SizedBox(width: 12,),
                                  Expanded(
                                    child: RoundedLoadingButton(child: Text("AJOUTER", style: TextStyle(fontSize: 18),),onPressed: () async{
                                      if(quantite.isGreaterThan(0)){
                                        var product  = widget.product;
                                        var stock = Stock();
                                        stock.product = widget.product;
                                        stock.productId = widget.product.id;
                                        stock.quantityEntree = quantite;
                                        quantite += product.quantity!;
                                        product.quantity = quantite;
                                        await produitRepository.updateProduct(product);
                                        await stockRepository.createStock(stock);
                                        setState(() {
                                          widget.product.quantity  = quantite;
                                          quantite = 0;
                                        });
                                        _btnController.reset();
                                        Get.close(1);
                                      }
                                    }, controller: _btnController,),
                                  )
                                ],
                              )
                            ],
                          )
                      )
                  )
              );
            }
          },
          currentIndex: bottomIndex,
          items: [
            FloatingNavbarItem(icon: Iconsax.direct_inbox, title: 'Ajouter'),
            FloatingNavbarItem(icon: Iconsax.direct_send, title: 'Achat'),
            FloatingNavbarItem(icon: Iconsax.global, title: 'Page'),
            FloatingNavbarItem(icon: Iconsax.edit_2, title: edit == false ?  "Modifier" : "Terminer"),
          ],
        ):
        Container(
          margin: EdgeInsets.symmetric(horizontal: GetPlatform.isDesktop || GetPlatform.isWeb ?Get.size.width / 5 : 15),
          child:  Container(
            padding: EdgeInsets.all(12),
            child: DefaultButton(text: "Terminer", press: (){
              setState(() {
                edit = false;
              });
            }),
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    /*if(GetPlatform.isWeb || GetPlatform.isDesktop){
      return DashboardLayout(child: body);
    }else {*/
      return body;
   // }
  }


}

