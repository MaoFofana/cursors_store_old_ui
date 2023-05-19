import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/components/table.dart';
import 'package:cs/layouts/dashboard_layout.dart';
import 'package:cs/model/Categorie.dart';
import 'package:cs/repository/CategorieRepossitory.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

import '../stock_screen.dart';
class CategorieScreen extends StatefulWidget {
  const CategorieScreen({Key? key}) : super(key: key);

  @override
  State<CategorieScreen> createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController textEditingController = TextEditingController();
  var categorieRepository = Get.put(CategorieRepository());
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  TextEditingController controllerSearch = TextEditingController();
  List<Categorie> items = [];
  List<Categorie> itemsAll = [];
  bool filtre  = false;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init();
  }

  _init() async{
    var categorieResponse = await categorieRepository.getAll();
    if(categorieResponse.statusCode == 200){
      setState(() {
        items.addAll(categorieResponse.body!);
        itemsAll.addAll(categorieResponse.body!);
        loading = false;
      });
    }else {
      setState(() {
        loading = false;
      });
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Dialog dialogCategorie({Categorie? categorie}){
      textEditingController.text = categorie?.name ??  '';
      return Dialog(child: Container(
        height: 200,
        width: GetPlatform.isMobile ? null : 400,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: "Ajouter le nom de la categorie"
              ),
            ),
            Row(
              children: [
                Expanded(child: DefaultButton(text: "Annuler", press: (){
                  Get.back();
                },color: Colors.red,)),
                SizedBox(width: 5,),
                Expanded(child: RoundedLoadingButton(
                  //color: kPrimaryColor,
                  borderRadius: 28,
                  controller: _btnController,
                  onPressed: ()async{
                    if(textEditingController.text.isNotEmpty){
                      if(categorie == null){
                        categorie = Categorie();
                        categorie!.name = textEditingController.text;
                        var response = await categorieRepository.createCategorie(categorie!);
                        if(response.statusCode == 200){
                          setState(() {
                            itemsAll.add(response.body!);
                            items.add(response.body!);
                            textEditingController.text = "";
                          });
                        }
                      }else {
                        categorie!.name = textEditingController.text;
                        var response = await categorieRepository.updateCategorie(categorie!);
                        if(response.statusCode == 200){
                          setState(() {
                            itemsAll[itemsAll.indexOf(categorie!)] =response.body!;
                            items[items.indexOf(categorie!)] =response.body!;
                            textEditingController.text = "";
                          });
                        }
                      }
                    }
                    _btnController.reset();
                    Get.back();
                  },
                  child: Text( "Enregister".toUpperCase(), style: TextStyle(color: Colors.white,fontSize: 18)),
                )),
              ],
            )
          ],
        ),
      ),);
  }


  Widget get body {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TableData(
        loading: loading,
        columns: [
          DataColumn(label: Text("Nom", style: TextStyle(fontWeight: FontWeight.bold),)),
          DataColumn(label: Text(''))
        ],
        rows: [
          ...List.generate(items.length, (index) => DataRow(
              cells: [
                DataCell(Text(items[index].name ?? '')),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        Get.dialog(dialogCategorie(categorie:items[index]));
                      });
                    }, icon: Icon(Iconsax.edit_2, color: kPrimaryColor,)),
                    IconButton(onPressed: (){
                      Get.defaultDialog(
                        radius: roundedValue,
                        middleText: "",
                        title: "Vous-voulez vous supprimé \n${items[index].name!}",
                        cancel: TextButton(onPressed: (){
                          Get.close(1);
                        }, child: Text("Non", style: TextStyle(color: Colors.red),)),
                        confirm: TextButton(onPressed: () async{
                          var item = items[index];
                          setState(() {
                            items.remove(item);
                            itemsAll.remove(item);
                          });
                          if(item.id != null){
                            var response = await categorieRepository.deleteCategorie(item.id!);
                          }
                          Get.close(1);
                        }, child: Text('Oui')),
                        cancelTextColor:  Colors.red,
                        confirmTextColor:  Colors.white,

                      );
                    }, icon: Icon(Iconsax.trash,color: Colors.red,)),
                  ],
                ))
              ]
          ))
        ],),
    );
  }
  @override
  Widget build(BuildContext context) {
 /*   if(GetPlatform.isDesktop || GetPlatform.isWeb){
      return DashboardLayout(
         title: 'Liste des categories',
          icon: Iconsax.box,
          rightMenu:  Row(
            children: [
              Expanded(
                flex : 4,
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
                    hintText: "Trouver une categorie",
                    prefixIcon: Icon(Iconsax.search_normal),
                  ),
                ),
              ),
              SizedBox(width: 2,),
              Expanded(
                child: DefaultButton(text: "Ajouter", press: (){
                  Get.dialog(dialogCategorie()) ;

                }, icon:Iconsax.add,),
              )
            ],
          ),
          child:body

      );
    }else{*/
      return WillPopScope(
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
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
                      hintText: "Trouver une categorie",
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
                Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
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
                    }, icon: Icon(Icons.close,color: Colors.red,))
                ],
              ),
              body: body,
              floatingActionButton: FloatingActionButton(
                backgroundColor: kPrimaryColor,
                onPressed: () { Get.dialog(dialogCategorie()) ;},
                child: Icon(Icons.add),
              ),
            ),
          ),
          onWillPop: () async{
            Get.to(StockScreenMain());
            return false;
          });
   // }

  }
}
