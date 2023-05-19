

import 'package:cs/components/bottom_menu.dart';
import 'package:cs/components/button.dart';
import 'package:cs/components/produit_card.dart';
import 'package:cs/components/table.dart';
import 'package:cs/layouts/dashboard_layout.dart';
import 'package:cs/model/Categorie.dart';
import 'package:cs/model/Magasin.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/model/Unite.dart';
import 'package:cs/repository/CategorieRepossitory.dart';
import 'package:cs/repository/MagasinRepository.dart';
import 'package:cs/repository/ProductRepository.dart';
import 'package:cs/repository/UniteRepository.dart';
import 'package:cs/screen/home/orders/order_screen.dart';
import 'package:cs/screen/stock/magasin/magasin_screen.dart';
import 'package:cs/screen/stock/product/add_product.dart';
import 'package:cs/screen/stock/product/view_product.dart';
import 'package:cs/screen/stock/rapport/component/rapport_select_modal.dart';
import 'package:cs/screen/stock/unites/unite_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/border.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'categories/categorie_screen.dart';

class StockScreenMain extends StatefulWidget {
  const StockScreenMain({Key? key}) : super(key: key);

  @override
  State<StockScreenMain> createState() => _StockScreenMainState();
}

class _StockScreenMainState extends State<StockScreenMain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController textEditingController = TextEditingController();
  var repository = Get.put(ProductRepository());

  TextEditingController controllerSearch = TextEditingController();
  var categorieRepository = Get.put(CategorieRepository());
  var uniteRepository = Get.put(UniteRepository());
  List<Product> items = [];
  List<Product> itemsAll = [];
  List<Categorie> categorieAll = [];
  List<Unite> unitesAll = [];
  bool filtre  = false;
  bool loading = true;
 int? categorieSelectedId;
  var magasinRepository  = Get.put(MagasinRepository());
  List<Magasin> magasins = [];
  int index = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init();

  }
  _init() async{
    var categorieResponse = await categorieRepository.getAll();
    var magasinReponse = await magasinRepository.getAll();
    var unitesReponse  = await uniteRepository.getAll();
    if(categorieResponse.statusCode == 200){
      var categories = categorieResponse.body!;
      List<Magasin> magasinsR = [];
      magasinsR.addAll(magasinReponse.body!);
      var unites = unitesReponse.body!;
      if(categories.isNotEmpty){
          var productsResponse = await repository.getByMagasinAndCategorie(magasinsR[index].id!.toString(),categories.first.id!.toString());
          if(productsResponse.statusCode == 200){
            var products = productsResponse.body!;
            setState(() {
              categorieAll.addAll(categories);
              categorieSelectedId = categories.first.id;
              itemsAll.addAll(products);
              items.addAll(products);
              unitesAll.addAll(unites);
              magasins = magasinsR;
              loading = false;
            });
          }else {
            setState(() {
              categorieAll.addAll(categories);
              categorieSelectedId = categories.first.id;
              unitesAll.addAll(unites);
              magasins = magasinsR;
              loading = false;
            });
          }
      }else {
        setState(() {
          unitesAll.addAll(unites);
          magasins = magasinsR;
          loading = false;
        });
      }
    }else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant StockScreenMain oldWidget) {
    // TODO: implement didUpdateWidget
    ////magasins.clear();
    //_init();
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    /*if(GetPlatform.isDesktop){
        return DashboardLayout(
            title: 'Liste des produits',
            icon: Iconsax.box,
            rightMenu: Row(
              children: [
                Expanded(
                  flex : 3,
                  child: TextFormField(
                    controller: controllerSearch,
                    onChanged: (value){
                      setState(() {
                        if(value.isNotEmpty){
                          items = itemsAll.where((element) => element.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                        }else {
                          items =itemsAll;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      filled: true, //<-- SEE HERE
                      fillColor: Colors.grey.shade200,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(left : 0, bottom : 0, top : 0, right: 0),
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      focusColor: Colors.grey.shade200,
                      border: outlineInputBorder,
                      disabledBorder: outlineInputBorder,
                      hintText: "Trouver un produit",
                      prefixIcon: Icon(Iconsax.search_normal),
                    ),
                  ),
                ),
                SizedBox(width: 2,),
                Container(
                  padding: EdgeInsets.only(bottom: 14, right: 12),
                  child: IconButton(
                    tooltip: "Magasin",
                    onPressed: (){
                    Get.dialog(Dialog(
                      child: Container(
                        height: 500,
                        width: 500,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: radius
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin : EdgeInsets.only(top: 5, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(), borderRadius: radius
                              ),
                              width: 50,
                            ),
                            Text("Liste des magasins", style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 30,),
                            Container(
                              height: 350,
                              child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...List.generate(magasins.length, (index) => ListTile(
                                        title: Text(magasins[index].name ?? ""),
                                        onTap : (){
                                          setState(() {
                                            this.index = index;
                                            Get.back();
                                          });
                                        },
                                        trailing: Icon(Iconsax.location_tick, color: index == this.index ?  Colors.green  : null,),
                                      ),)
                                    ],
                                  )
                              ),
                            )

                          ],
                        ),
                      ),
                    ));
                  }, icon: Icon(Iconsax.home_hashtag,color: kPrimaryColor,size: 40,),
                )),
                SizedBox(width: 2,),
                Expanded(
                  flex: 1,
                  child:Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    height: 42,
                    padding: EdgeInsets.only(bottom: 5, right: 10,left: 10),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: radius
                    ),
                    child: DropdownButtonHideUnderline(
                      child:  DropdownButton<int?>(
                        dropdownColor: kPrimaryColor,
                        icon: Container(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(Iconsax.arrow_down_1, color: Colors.white,size: 20,),
                        ),
                        elevation: 2,
                        value: categorieAll.isNotEmpty ? categorieAll.first.id : null,
                        hint: Text('Selectionner.',style: TextStyle(color: Colors.white),),
                        onChanged: (int? id) async {
                          itemsAll.clear();
                          items.clear();
                          setState(() {
                            loading = true;
                          });
                          var productsResponse = await repository.getByMagasinAndCategorie(magasins[index].id!.toString(),id!.toString());
                          if(productsResponse.statusCode == 200){
                            var products = productsResponse.body!;
                            setState(() {
                              itemsAll.addAll(products);
                              items.addAll(products);
                              loading = false;
                            });
                          }else {
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        items: categorieAll.map((Categorie value) {
                          return DropdownMenuItem<int?>(
                            value: value.id!,
                            child: Text(value.name!, style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: DefaultButton(text: "Ajouter", press: (){
                    Get.to(AddProduct());
                  }, icon:Iconsax.add,),
                )
              ],
            ),
            child: TableData(
                loading: loading,
                columns: [
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Code')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Categorie')),
                  DataColumn(label: Text('Unite')),
                  DataColumn(label: Text('Magasin')),
                  DataColumn(label: Text('Quantité')),
                  DataColumn(label: Text('Prix')),
                  DataColumn(label: Text('Actions')),
                ], rows: [
              ...List.generate(items.length, (index)
              => DataRow(cells: [
                DataCell(CircleAvatar(
                  radius: 18,
                  backgroundImage: items[index].images != null &&  items[index].images!.isNotEmpty ? NetworkImage("${items[index].images![0].url}")  : null,
                )),
                DataCell(Text(items[index].code ?? "")),
                DataCell(Text(items[index].name ?? "")),
                DataCell(Text("${items[index].categorie!.name}")),
                DataCell(Text("${items[index].unite}")),
                DataCell(Text("${items[index].magasin!.name!.capitalize}")),
                DataCell(Container(
                  width: double.infinity,
                  child: Text(items[index].quantity!.toString(), textAlign: TextAlign.right,),
                )),
                DataCell(Text(items[index].price!.toString(), textAlign: TextAlign.right,)),
                DataCell(Row(
                  children: [
                    IconButton(onPressed: (){
                      Get.to(ViewProduct(product: items[index]));
                    }, icon: const Icon(Iconsax.eye,color: Colors.greenAccent,)),
                    IconButton(onPressed: (){
                      Get.dialog(RapportSelectModal(product: items[index],));
                    }, icon:Icon(Iconsax.activity)),
                    IconButton(onPressed: (){
                      Get.defaultDialog(
                        radius: roundedValue,
                        middleText: "",
                        title: "Vous-voulez vous supprimé \n${items[index].name!}",
                        cancel: TextButton(onPressed: (){
                          Get.close(1);
                        }, child: Text("Non", style: TextStyle(color: Colors.red),)),
                        confirm: TextButton(onPressed: () async{
                          var produit = items[index];
                          setState(() {
                            items.remove(produit);
                            itemsAll.remove(produit);
                          });
                          if(produit.id != null) {
                            var response = await repository.deleteProduct(produit.id!);
                          }
                          Get.close(1);
                        }, child: Text('Oui')),
                        cancelTextColor: Colors.red,
                        confirmTextColor:  Colors.white,
                      );

                    }, icon: Icon(Iconsax.trash,color: Colors.red,)),
                  ],
                )),
              ]))
            ])
        );
    }else {*/
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: filtre == true ?
            TextFormField(
              controller: controllerSearch,
              onChanged: (value){
                setState(() {
                  if(value.isNotEmpty){
                    items = itemsAll.where((element) => element.name!.toLowerCase().startsWith(value.toLowerCase())).toList();
                  }else {
                    items =itemsAll;
                  }
                });
              },
              decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Colors.grey.shade200,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(left : 0, bottom : 0, top : 0, right: 0),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  focusColor: Colors.grey.shade200,
                  border: outlineInputBorder,
                  disabledBorder: outlineInputBorder,
                  hintText: "Trouver un produit",
                  prefixIcon: Icon(Iconsax.search_normal),
                  suffixIcon:controllerSearch.text.isNotEmpty ?  InkWell(
                    onTap: (){
                      setState(() {
                        controllerSearch.text = "";
                      });
                    },
                    child: Icon(Icons.close, color: Colors.red,),) : null
              ),
            )
                :
            Text("Boutique", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
            actions: [
              if(filtre == false)
                IconButton(onPressed: (){
                  setState(() {
                    filtre = true;
                  });
                }, icon: Icon(Iconsax.search_normal,color: Colors.black,)),
              if(filtre == true)
                IconButton(onPressed: (){
                  setState(() {
                    filtre = false;
                  });
                }, icon: Icon(Icons.close,color: Colors.red,)),
    /* if(filtre == false)
                IconButton(onPressed: (){
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context, builder: (builder){
                    return StatefulBuilder(
                      builder: (context, state){
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(roundedValue * 3),
                            topRight: Radius.circular(roundedValue * 3),
                          ),
                          child: Container(
                            height: 500,
                            decoration: BoxDecoration(
                              color: white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin : EdgeInsets.only(top: 5, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: Border.all(), borderRadius: radius
                                  ),
                                  width: 50,
                                ),
                                Text("Liste des magasins", style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 30,),
                                Container(
                                  height: 350,
                                  child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ...List.generate(magasins.length, (index) => ListTile(
                                            title: Text(magasins[index].name ?? ""),
                                            onTap : (){
                                              setState(() {
                                                this.index = index;
                                                Get.back();
                                              });
                                            },
                                            trailing: Icon(Iconsax.location_tick, color: index == this.index ?  Colors.green  : null,),
                                          ),)
                                        ],
                                      )
                                  ),
                                )

                              ],
                            ),
                          ),
                        );
                      },
                    );

                  });
                }, icon: Icon(Iconsax.home_hashtag,color: Colors.black,)),
             if(filtre == false)
              IconButton(onPressed: (){
               // Get.to(OrderScreen());
              }, icon: Icon(Iconsax.global,color: Colors.black,))*/
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child:  Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child:DropdownButtonHideUnderline(
                  child:  DropdownButton<int?>(
                    value: categorieSelectedId,
                    hint: Text('Selectionner une categorie',),
                    onChanged: (int? id) async {
                      itemsAll.clear();
                      items.clear();
                      setState(() {
                        loading = true;
                        categorieSelectedId = id!;
                      });
                      var productsResponse = await repository.getByMagasinAndCategorie(magasins[index].id!.toString(),id!.toString());
                      if(productsResponse.statusCode == 200){
                        var products = productsResponse.body!;
                        setState(() {
                          itemsAll.addAll(products);
                          items.addAll(products);
                          loading = false;
                        });
                      }else {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    items: categorieAll.map((Categorie value) {
                      return DropdownMenuItem<int?>(
                        value: value.id!,
                        child: Text(value.name!, style: TextStyle(fontSize: 20)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [

                    ...List.generate(items.length, (index) => Dismissible(
                      direction: DismissDirection.endToStart,
                      key: UniqueKey(),
                      onDismissed: (direction) async{
                        var response = await repository.deleteProduct(items[index].id!);
                        if(response.statusCode == 200){
                          setState(() {
                            items.removeAt(index);
                          });
                        }
                      },
                      child: ProduitCard(product: items[index],),
                      background: Container(color: Colors.white,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Iconsax.trash, color: danger,size: 30,)
                          ],
                        ),),
                    )),
                  if( items.isEmpty && loading == false)
                    Image.asset("assets/images/empty.jpg", width: 300,),
                  if(items.isEmpty && loading == false)
                    Text("Aucun item n'a été ajouter", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),textAlign: TextAlign.center,),
                  if( items.isEmpty && loading == true)
                    Container(
                      alignment: Alignment.center,
                      height: 300,
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: SpeedDial(
            backgroundColor: kPrimaryColor,
            icon: Iconsax.task_square,
            activeIcon: Icons.close,
            spaceBetweenChildren: 4,
            elevation: 8.0,
            animationCurve: Curves.elasticInOut,
            isOpenOnStart: false,
            children: [
              SpeedDialChild(
                  child: Icon(Iconsax.add),
                  label: 'Ajouter un produit',
                  onTap: (){
                    if(categorieAll.isEmpty){
                      Get.dialog(Dialog(child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Vous devez ajouter une \ncategorie avant de continuer", style: TextStyle(fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(onPressed: (){
                                  Get.close(1);
                                }, child: Text('REFUSER', style: TextStyle(color: Colors.red),)),
                                TextButton(onPressed: ()async{
                                  Get.close(1);
                                  Get.to(CategorieScreen());
                                }, child: Text('AJOUTER', style: TextStyle(color: kPrimaryColor),)),
                              ],
                            )
                          ],
                        )
                        ,),));
                    }/*else if(unitesAll.isEmpty) {
                      Get.dialog(Dialog(child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Vous devez ajouter une \nunité avant de continuer", style: TextStyle(fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(onPressed: (){
                                  Get.close(1);
                                }, child: Text('REFUSER', style: TextStyle(color: Colors.red),)),
                                TextButton(onPressed: ()async{
                                  Get.close(1);
                                  Get.to(UniteScreen());
                                }, child: Text('AJOUTER', style: TextStyle(color: kPrimaryColor),)),
                              ],
                            )
                          ],
                        )
                        ,),));
                    }*/else {
                      Get.to(AddProduct());
                    }
                  }
              ),
            SpeedDialChild(
                child: Icon(Iconsax.shopping_cart),
                label: 'Commandes',
                onTap: (){
                  Get.to(OrderScreen());
                }
            ),
              SpeedDialChild(
                  child: Icon(Iconsax.box),
                  label: 'Categories',
                  onTap: (){
                    Get.to(CategorieScreen());
                  }
              ),
              SpeedDialChild(
                  child:Icon(Iconsax.directbox_notif),
                  label: 'Unités',
                  onTap: (){Get.to(UniteScreen());}
              ),
             SpeedDialChild(
                child: Icon(Iconsax.home_hashtag),
                label: 'Magasins',
                onTap: (){
                  Get.to(MagasinScreen());
                },
              ),
              SpeedDialChild(
                child: Icon(Iconsax.activity),
                label: 'Rapports',
                onTap: (){
                  Get.dialog(RapportSelectModal());
                },
              ),

            ],
          ) ,
          bottomNavigationBar: BottomMenu(index: 1),
        ),
      );
    //}

  }
}
