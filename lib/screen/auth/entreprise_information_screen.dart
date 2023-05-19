import 'dart:io';

import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/repository/FileRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntrepriseInformationScreen extends StatefulWidget {
  const EntrepriseInformationScreen({Key? key}) : super(key: key);

  @override
  State<EntrepriseInformationScreen> createState() => _EntrepriseInformationScreenState();
}

class _EntrepriseInformationScreenState extends State<EntrepriseInformationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var repository = Get.put(UserRepository());
  String? imagePath;
  RoundedLoadingButtonController _controllerBounded = RoundedLoadingButtonController();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    nameController.text = userAuth!.name ?? "";
    adresseController.text = userAuth!.adresse ?? "";
    emailController.text = userAuth!.email ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Entreprise", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),),
          actions: [

          ],
        ),
        body:
        SingleChildScrollView(
          child:  Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png'],
                    );
                    if (result != null) {
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
                      child: userAuth!.avatarUrl == null ? CircleAvatar(
                        radius: 70,
                        backgroundImage:FileImage(File(imagePath ?? "")) ,
                      ) :Image.network("${ userAuth!.avatarUrl}", width: 120,height: 120,),
                    ) ,
                  ),
                ),
                SizedBox(height: 12,),
                Text("Entrer les informations de votre entreprise",textAlign: TextAlign.center,),
                SizedBox(height: 12,),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: "Entrer le nom de votre entreprise"
                  ),
                  onChanged: (String nom){
                    setState(() {
                      userAuth!.name = nom;
                    });
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: adresseController,
                  decoration: InputDecoration(
                      hintText: "Entrer votre localisation"
                  ),
                  onChanged: (String value){
                    setState(() {
                      userAuth!.adresse = value;
                    });
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Entrer  votre email"
                  ),
                  onChanged: (String value){
                    setState(() {
                      userAuth!.email = value;
                    });
                  },
                ),
                SizedBox(height: 12,),
                RoundedLoadingButton(
                  controller: _controllerBounded,
                    child: Text("Enregistrer".toUpperCase()), onPressed: () async{
                    if(imagePath != null ){
                      var  fileRepository = Get.put(FileRepository());
                      var imageResponse  =await fileRepository.save(File(imagePath!).readAsBytesSync());
                      var url = imageResponse.body["name"];
                      userAuth!.avatarUrl = url;
                    }
                    await repository.updateUser(userAuth!);
                    Get.to(HomeScreen());
                    _controllerBounded.reset();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
