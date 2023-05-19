import 'dart:io';

import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/components/title.dart';
import 'package:cs/model/User.dart';
import 'package:cs/repository/AuthentificationRepository.dart';
import 'package:cs/repository/FileRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:easy_container/easy_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cs/screen/auth/verify_phone_number_screen.dart';

import '../utils/helpers.dart';
import 'login_screnn.dart';

class PasswordScreen extends StatefulWidget {

  const PasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController emailController = TextEditingController();
  var repository = Get.put(UserRepository());
  String? imagePath;
  RoundedLoadingButtonController _controllerBounded = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  String? error;
  bool send = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text("Mot de passe oublié", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        backgroundColor:Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: send == true ?
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.clipboard_tick, color:  Colors.green,size: 50,),
                SizedBox(height: 12,),
                Text('Un noueau code vous a été envoyer par mail',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(child:  DefaultButton(text: "Me connecter", press: (){
                      Get.to(LoginScreen());
                    }))

                  ],
                )
              ],
            ),
          ) :
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Container(
                  width: GetPlatform.isMobile ? null : 500,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 100,),
                      title(40),
                      SizedBox(height: 10,),
                      Text("Recevoir un nouveau mot de passe par email",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey.shade700),),
                      SizedBox(height: 70,),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Entrer  votre email"
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "L'email est obligatoire";
                          }else if(!value.isEmail){
                            return "Veuillez entrer un email valide";
                          }
                          return  null;
                        },
                      ),
                      SizedBox(height: 12,),
                      if(error != null)
                        Text(error!, style: TextStyle(color: danger,fontSize: 8),),
                      if(error != null)
                        SizedBox(height: 12,),

                      RoundedLoadingButton(
                          controller: _controllerBounded,
                          child: Text("Envoyer".toUpperCase()), onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          var user = User();
                          if(imagePath != null ){
                            var  fileRepository = Get.put(FileRepository());
                            var imageResponse  =await fileRepository.save(File(imagePath!).readAsBytesSync());
                            var url = imageResponse.body["name"];
                            user.avatarUrl = url;
                          }

                          var response = await repository.sendCoteEmail(emailController.text);
                          if(response.statusCode == 200){
                            setState(() {
                              send = true;
                            });
                          }else {
                            error = "Une erreur est apparue";
                            await Future.delayed(Duration(seconds: 5));
                            setState(() {
                              error = null;
                            });
                          }
                          _controllerBounded.reset();
                        }else {
                          _controllerBounded.reset();
                        }
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
