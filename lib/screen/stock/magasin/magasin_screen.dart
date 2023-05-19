import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/layouts/dashboard_layout.dart';
import 'package:cs/model/Magasin.dart';
import 'package:cs/model/User.dart';
import 'package:cs/repository/MagasinRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/border.dart';
import 'package:cs/theme/colors.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'components/magasin_information.dart';

class MagasinScreen extends StatefulWidget {
  const MagasinScreen({Key? key}) : super(key: key);

  @override
  State<MagasinScreen> createState() => _MagasinScreenState();
}

class _MagasinScreenState extends State<MagasinScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  bool filtre = false;
  var repository = Get.put(MagasinRepository());
  var userRepository = Get.put(UserRepository());
  TextEditingController controllerSearch = TextEditingController();
  List<Magasin> items = [];
  List<Magasin> itemsAll = [];
  List<User> userEntreprises = [];
  bool loading = true;
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  String? magasinName;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init();
  }


  _init() async{
    var response = await repository.getAll();
    var responseUser = await userRepository.getEntrepriseUser(userAuth!.id!);
    if(response.statusCode == 200){
      setState(() {
        items.addAll(response.body!);
        itemsAll.addAll(response.body!);
        userEntreprises.addAll(responseUser.body!);
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

  Dialog get dialogMagasin{
  return Dialog(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 290,
      width: GetPlatform.isMobile ? null : 450,
      child: Column(
        children: [
          Text(
            "Remplisser les champs \npour creer un magasin",
            style: TextStyle(fontSize: 22),textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: InputDecoration(
                hintText: "Entrer le nom du magasin",
                prefixIcon: Icon(Iconsax.home_hashtag)
            ),
            onChanged: (String value){
              setState(() {
                magasinName = value;
              });
            },
          ),
          const SizedBox(height: 15),
          Form(
            key: _formKey,
            child: IntlPhoneField(
              flagsButtonMargin: EdgeInsets.symmetric(horizontal: 5),
              invalidNumberMessage: 'Numéro incorrect!',
              decoration: InputDecoration(
                  hintText: "Contact du responsable",
                  hintStyle: TextStyle(fontSize: 15)
              ),
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 25),
              onChanged: (phone) => phoneNumber = phone.completeNumber,
              initialCountryCode: 'CI',
              flagsButtonPadding: const EdgeInsets.only(right: 10),
              showDropdownIcon: false,
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child:  Row(
              children: [
                Expanded(child:  DefaultButton(text: "Anuller",press: ()async{
                  Get.close(1);
                },color: danger,)),
                SizedBox(width: 5,),
                Expanded(
                  child: RoundedLoadingButton(child: Text("Valider".toUpperCase(), style: TextStyle(fontSize: 18),),onPressed: ()async{
                    var magasin = Magasin();
                    magasin.name = magasinName;
                    var reponseMagasin = await repository.createMagasin(magasin);
                    if(reponseMagasin.statusCode == 200){
                      magasin = reponseMagasin.body!;
                      var response = await userRepository.affecterUser(
                          { "phone" : phoneNumber , "magasin_id" : reponseMagasin.body!.id, "patron_id": userAuth!.id});
                      setState(() {
                        magasin.gerant = response.body!;
                        magasin.gerantId = response.body!.id;
                        items.add(magasin);
                        itemsAll.add(magasin);
                      });
                    }
                    _btnController.reset();
                    Get.close(1);

                  }, controller: _btnController,),
                ),
              ],
            ),
          ),


        ],
      ),
    ),
    );
  }

  Widget get body {
      return  SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child:  Column(
              children: [
                ...List.generate(items.length, (index) => MagasinInformation(key : UniqueKey(),magasin: items.toList()[index],delete: (Magasin item){
                  setState(() {
                    items.removeWhere((element) => element.name == item.name!);
                    itemsAll.removeWhere((element) => element.name == item.name!);
                  });
                },users: userEntreprises,))

              ],
            )
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
   /* if (GetPlatform.isDesktop || GetPlatform.isWeb) {
      return DashboardLayout(
          rightMenu: Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: controllerSearch,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        items = itemsAll.where((element) =>
                            element.name!.toLowerCase().startsWith(
                                value.toLowerCase())).toList();
                      } else {
                        items = itemsAll;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.grey.shade200,
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always,
                    contentPadding: EdgeInsets.only(
                        left: 0, bottom: 0, top: 0, right: 0),
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    focusColor: Colors.grey.shade200,
                    border: outlineInputBorder,
                    disabledBorder: outlineInputBorder,
                    hintText: "Trouver une unité",
                    prefixIcon: Icon(Iconsax.search_normal),
                  ),
                ),
              ),
              SizedBox(width: 2,),
              Expanded(
                child: DefaultButton(text: "Ajouter", press: () {
                  Get.dialog(dialogMagasin);
                }, icon: Iconsax.add,),
              )
            ],
          ),
          title: 'Liste des magasins',
          icon: Iconsax.home_hashtag,
          child:body
      );
    } else {*/
      return WillPopScope(child: SafeArea(
        child: Scaffold(

          appBar: AppBar(
            // centerTitle: true,
            title: filtre == true ?
            TextFormField(
              controller: controllerSearch,
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    items = itemsAll.where((element) =>
                        element.name!.toLowerCase().startsWith(
                            value.toLowerCase())).toList();
                  } else {
                    items = itemsAll;
                  }
                });
              },
              decoration: InputDecoration(
                  filled: true,
                  //<-- SEE HERE
                  fillColor: Colors.grey.shade200,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(
                      left: 0, bottom: 0, top: 0, right: 0),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  focusColor: Colors.grey.shade200,
                  border: outlineInputBorder,
                  disabledBorder: outlineInputBorder,
                  hintText: "Trouver un magasin",
                  prefixIcon: Icon(Iconsax.search_normal),
                  suffixIcon: controllerSearch.text.isNotEmpty ? InkWell(
                    onTap: () {
                      setState(() {
                        controllerSearch.text = "";
                      });
                    },
                    child: Icon(Icons.close, color: Colors.red,),) : null
              ),
            )
                :
            Text("Magasins", style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black),),
            actions: [
              if(filtre == true)
                IconButton(onPressed: () {
                  setState(() {
                    filtre = false;
                  });
                }, icon: Icon(Icons.close, color: Colors.black,)),
              if(filtre == false)
                IconButton(onPressed: () {
                  setState(() {
                    filtre = true;
                  });
                }, icon: Icon(Iconsax.search_normal, color: Colors.black,))
            ],
          ),
          body: body,
          floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Get.dialog(dialogMagasin);
              },
              child: Icon(Iconsax.add)
          ),
        ),
      ),
          onWillPop: () async {
            Get.to(StockScreenMain());
            return false;
          });
   // }
  }
}
