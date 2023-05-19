import 'dart:io';

import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/components/title.dart';
import 'package:cs/model/User.dart';
import 'package:cs/repository/AuthentificationRepository.dart';
import 'package:cs/repository/FileRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/screen/auth/authentication_screen.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:easy_container/easy_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cs/screen/auth/verify_phone_number_screen.dart';

import '../utils/helpers.dart';
import 'password_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var repositoryAuth = Get.put(AuthenficationRepository());
  var repository = Get.put(UserRepository());
  String? imagePath;
  RoundedLoadingButtonController _controllerBounded = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  String? error;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Connexion", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        backgroundColor:Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child:  Column(
                children: [
                  SizedBox(height: 100,),
                  title(40),
                  SizedBox(height: 10,),
                  Text("Connectez-vous",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey.shade700),),
                  SizedBox(height: 70,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Entrer  un  email"
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
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "Entrer  un mot de passe"
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Le mot de passe est obligatoire";
                      }
                      return  null;
                    },
                  ),
                  SizedBox(height: 12,),
                  if(error != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text(error!, style: TextStyle(color: danger,fontSize: 12),),],),
                  if(error != null)
                    SizedBox(height: 12,),

                  RoundedLoadingButton(
                      controller: _controllerBounded,
                      child: Text("Se connecter".toUpperCase()), onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      var data = {
                        'email' : emailController.text,
                        "password" : passwordController.text
                      };
                      var response = await repositoryAuth.login(data);
                      logger.d(response.statusCode);
                      if(response.statusCode == 200){
                        if(response.body['message'] == "VALIDE") {
                          userAuth = User.fromJson(response.body['user']);
                          storage.write("user", userAuth!.toJson());
                          storage.write(
                              "token", response.body['token']['token']);

                          FirebaseMessaging messaging = FirebaseMessaging.instance;
                          messaging.getToken().then((value)async{
                            userAuth!.firebase = value;
                            await  repository.updateUser(userAuth!);
                            logger.d(value);
                          });

                          Get.to(HomeScreen());
                        }
                      }else {
                        setState(() {
                          error = "Une erreur est apparue, verifier votre email ou mot de passe";
                        });
                        _controllerBounded.reset();
                        await Future.delayed(Duration(seconds: 10));
                        setState(() {
                          error = null;
                        });

                      }
                      _controllerBounded.reset();
                    }else {
                      _controllerBounded.reset();
                    }
                  }),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: (){Get.to(PasswordScreen());},child: Text('Mot de passe oublié ? ', style: TextStyle(fontSize: 14, decoration: TextDecoration.underline),),),

                      InkWell(onTap: (){Get.to(AuthenticationScreen());},child: Text("Creer un nouveau compte ?", style: TextStyle(fontSize: 14, decoration: TextDecoration.underline),),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
