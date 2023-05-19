import 'dart:async';
import 'dart:io';
import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/layouts/dashboard_layout.dart';
import 'package:cs/model/Categorie.dart';
import 'package:cs/model/Magasin.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/model/Unite.dart';
import 'package:cs/repository/CategorieRepossitory.dart';
import 'package:cs/repository/FileRepository.dart';
import 'package:cs/repository/ImageRepository.dart';
import 'package:cs/repository/MagasinRepository.dart';
import 'package:cs/repository/ProductRepository.dart';
import 'package:cs/repository/UniteRepository.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cs/model/Image.dart' as image_save;
import 'package:iconsax/iconsax.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});


  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? notification;
  String? imagePath;
  Product produit = Product();
  List<Categorie> familles = [];
  List<Unite> unites = [];
  List<Magasin> magasins = [];
  // List of items in our dropdown menu
  var famillesRepository = Get.put(CategorieRepository());
  var uniteRepository =  Get.put(UniteRepository());
  var productRepository =  Get.put(ProductRepository());
  var magasinRepository = Get.put(MagasinRepository());
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
   bool save = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initGetAsync();
  }
  _initGetAsync () async{
    var response = await uniteRepository.getAll();
    if(response.statusCode == 200){
      setState(() {
        unites.addAll(response.body!);
      });
    }
    var repsonseFamille = await famillesRepository.getAll();
    if(repsonseFamille.statusCode == 200){
      setState(() {
        familles.addAll(repsonseFamille.body!);
      });
    }
    List<Magasin> magasins = [];
    //magasins.add(userAuth!.magasin_gerer!);
    var responseMagason = await magasinRepository.getAll();
    if(responseMagason.statusCode  == 200){
      magasins.addAll(responseMagason.body!);
    }
    setState(() {
      this.magasins = magasins;
    });
  }


  Widget get body {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: GetPlatform.isDesktop || GetPlatform.isWeb ? false : true,
        title: const Text("Ajouter un produit"),
        centerTitle: true,
      ),
      body: SafeArea(
        child:SingleChildScrollView(
          child:  SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:GetPlatform.isDesktop || GetPlatform.isWeb ?Get.size.width / 5 : 15),
              child: save == false ?
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Enregistrer les informations du produit",
                    textAlign: TextAlign.center,style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child:Column(
                      children: [
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kPrimaryColor,
                              ),
                            ),
                            child: Center(
                              child: produit.images == null ? CircleAvatar(
                                radius: 70,
                                backgroundImage:FileImage(File(imagePath ?? "")) ,
                              ) :Image.network("${produit.images![0].url}", width: 120,height: 120,),
                            ) ,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Cliquer sur le cercle pour charger une image", style: TextStyle(fontSize: 12),),
                        const SizedBox(
                          height: 20,
                        ),
                        buildCodeFormField(),
                        const SizedBox(
                          height: 20,
                        ),
                        buildDesignationFormField(),
                        const SizedBox(
                          height: 20,
                        ),
                        buildDescriptionFormField(),
                        const SizedBox(
                          height: 20,
                        ),
                        if(familles.length.isGreaterThan(1))
                          DropdownButtonFormField(
                            decoration: const  InputDecoration(
                              hintText: 'Selectionnez la categorie du produit',
                              //labelText: "Email",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              //suffixIcon: Icon(IconlyLight.location)
                            ),
                            // Initial Value
                            value: produit.categorie != null ?  produit.categorie!.name : null,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: familles.map((Categorie items) {
                              return DropdownMenuItem(
                                value: items.name,
                                child: Text("${items.name}"),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                produit.categorieId = familles.singleWhere((element) => element.name == newValue).id;
                              });
                            },
                          ),
                        if(familles.length.isGreaterThan(1))
                          const SizedBox(
                            height: 20,
                          ),
                        if(unites.length.isGreaterThan(1))
                          DropdownButtonFormField(
                            decoration: const  InputDecoration(
                              hintText: "Selectionnez l'unité du produit",
                              //labelText: "Email",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              //suffixIcon: Icon(IconlyLight.location)
                            ),
                            // Initial Value
                            value:  produit.unite,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: unites.map((Unite items) {
                              return DropdownMenuItem(
                                value: items.name,
                                child: Text(items.name!),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                produit.unite = newValue!;
                              });
                            },
                          ),
                        if(unites.length.isGreaterThan(1))
                          const SizedBox(
                            height: 20,
                          ),
                        /*if(magasins.length.isGreaterThan(1))
                          DropdownButtonFormField(
                            decoration: const  InputDecoration(
                              hintText: "Selectionnez un magasin",
                              //labelText: "Email",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              //suffixIcon: Icon(IconlyLight.location)
                            ),
                            // Initial Value
                            value:  produit.magasinId,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: magasins.map((Magasin items) {
                              return DropdownMenuItem(
                                value: items.id,
                                child: Text(items.name!),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (int? newValue) {
                              setState(() {
                                produit.magasinId = newValue;
                              });
                            },
                          ),
                        if(magasins.length.isGreaterThan(1))
                          const SizedBox(
                            height: 20,
                          ),*/

                        buildQuantiteFormField(),
                        const SizedBox(
                          height: 20,
                        ),
                        buildSeuilFormField(),
                        const SizedBox(
                          height: 20,
                        ),
                        buildPrixFormField(),
                        const SizedBox(
                          height: 20,
                        ),
                        buildReductionFormField()
                      ],
                    ) ,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(notification == null ? "" : "$notification", style: TextStyle(color: danger,fontSize: 12),),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(top : 12,bottom: 12),
                    decoration:const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.5, color: Colors.black12),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: DefaultButton(text: "Annuler", press: (){
                        Get.to(StockScreenMain());
                      },color: danger,)),
                      SizedBox(width: 5,),
                      Expanded(child: RoundedLoadingButton(
                        //color: kPrimaryColor,
                        borderRadius: 28,
                        controller: _btnController,
                        onPressed: ()async{
                          if(magasins.length.isGreaterThan(1) && produit.magasinId == null){
                            setState(() {
                              notification ="Veuillez selectionner un magasin";
                            });
                            _btnController.reset();
                            await Future.delayed(const Duration(seconds: 20), () {
                              setState(() {
                                notification = "";
                              });
                            });
                          }else {
                            if(unites.length.isGreaterThan(1)){
                              setState(() {
                                notification ="Veuillez selectionner une unité";
                              });
                              _btnController.reset();
                              await Future.delayed(const Duration(seconds: 20), () {
                                setState(() {
                                  notification = "";
                                });
                              });
                            }else {
                              if(familles.length.isGreaterThan(1) && produit.categorieId == null){
                                setState(() {
                                  notification ="Veuillez selectionner une categorie";
                                });
                                _btnController.reset();
                                await Future.delayed(const Duration(seconds: 20), () {
                                  setState(() {
                                    notification = "";
                                  });
                                });
                              }else {
                                if(imagePath != null){
                                  var controller = Get.put(ProductRepository());
                                  produit.seuil ??= 2;
                                  if(magasins.length == 1){
                                    produit.magasinId = magasins.first.id;
                                  }
                                  if(familles.length == 1){
                                    produit.categorieId = familles.first.id;
                                  }
                                  if(unites.length == 1){
                                    produit.unite = unites.first.name;
                                  }

                                  var response = await controller.createProduct(produit);
                                  if(response.statusCode == 200){
                                    FileRepository fileRepository = Get.put(FileRepository());
                                    ImageRepository imageRepository = Get.put(ImageRepository());

                                    var imageResponse  =await fileRepository.save(File(imagePath!).readAsBytesSync());

                                    image_save.Image image = image_save.Image();
                                    image.url  = imageResponse.body["name"];
                                    image.productId = response.body!.id;
                                    var resI = await imageRepository.createImage(image);
                                    _btnController.reset();
                                    setState(() {
                                      save = true;
                                    });

                                  }else  {
                                    setState(() {
                                      notification = "Une erreur est survenu, veuillez réessayer";
                                    });
                                    _btnController.reset();
                                    await Future.delayed(const Duration(seconds: 10), () {
                                      setState(() {
                                        notification = "";
                                      });
                                    });
                                  }

                                }else {
                                  setState(() {
                                    notification ="Veuillez selectionner une image";
                                  });
                                  _btnController.reset();
                                  await Future.delayed(const Duration(seconds: 20), () {
                                    setState(() {
                                      notification = "";
                                    });
                                  });
                                }
                              }
                            }

                          }
                        },
                        child: Text( "Enregister".toUpperCase(), style: TextStyle(color: Colors.white,fontSize: 18)),
                      )),
                    ],
                  )
                ],
              ):
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.clipboard_tick, color:  Colors.green,size: 50,),
                    SizedBox(height: 12,),
                    Text('Enregistremennt effectuer avec succes',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32), textAlign: TextAlign.center,),
                    SizedBox(height: 12,),
                    Row(
                      children: [
                        Expanded(child:  DefaultButton(text: "Terminer", press: (){
                          Get.to(StockScreenMain());
                        }, color: danger,)),
                        SizedBox(width: 12,),
                        Expanded(child:  DefaultButton(text: "Ajouter", press: (){
                          setState(() {
                            save = false;
                            imagePath = null;
                            produit  = Product();
                            Get.reload();
                          });
                        }))


                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  @override
  Widget build(BuildContext context) {
  /*  if(GetPlatform.isDesktop || GetPlatform.isWeb){
        return DashboardLayout(
            child:body
        );
    }else {*/
      return body;
//    }

  }

  TextFormField buildCodeFormField() {
    return TextFormField(
        decoration:const  InputDecoration(
          hintText: "Entrer le code du produit",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      onChanged: (value) {
        if(value.isNotEmpty){
          setState(() {
            produit.code = value;
          });
        }
      },
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      minLines: 5,
      maxLines: 6,
      decoration:const  InputDecoration(
        hintText: "Entrer la description  du produit",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {
        if(value.isNotEmpty){
          setState(() {
            produit.description = value;
          });
        }
      },
    );
  }

  TextFormField buildQuantiteFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
        decoration:const  InputDecoration(
          hintText: "Entrer la quantité du produit",
          //labelText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          //suffixIcon: Icon(IconlyLight.location)
        ),
      onChanged: (value) {
        if(value.isNumericOnly){
          setState(() {
            produit.quantity = int.parse(value);
          });
        }
      },
    );
  }

  TextFormField buildReductionFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration:const  InputDecoration(
        hintText: "Entrer une reduction au produit(30)",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffix:SizedBox(width : 30,child: Align(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12),child: Text("%", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),),alignment: Alignment.centerRight,),)

      ),
      onChanged: (value) {
        if(value.isNumericOnly && double.parse(value) < 101 && double.parse(value) > -1){
          setState(() {
            produit.reduction = double.parse(value);
          });
        }
      },
    );
  }

  TextFormField buildDesignationFormField() {
    return TextFormField(
        decoration:const  InputDecoration(
          hintText: "Entrer la désignation du produit",
          //labelText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // suffixIcon: Icon(IconlyLight.location)
        ),
      onChanged: (value) {
        if(value.isNotEmpty){
          setState(() {
            produit.name = value;
          });
        }
      },
    );
  }

  TextFormField buildSeuilFormField() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration:const  InputDecoration(
          hintText: "Entrer le seuil du produit",
          //labelText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          //  suffixIcon: Icon(IconlyLight.location)
        ),
      onChanged: (value) {
        if(value.isNumericOnly){
          setState(() {
            produit.seuil = int.parse(value);
          });
        }
      },
    );
  }
  TextFormField buildPrixFormField() {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration:const  InputDecoration(
          hintText: "Entrer le prix du produit",
          //labelText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          //suffixIcon: Icon(IconlyLight.location)
        ),
      onChanged: (value) {
          if(value.isNumericOnly){
            setState(() {
              produit.price = double.parse(value);
            });
          }
      },
    );
  }



}






