import 'dart:math';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/model/User.dart';
import 'package:cs/qr/qr_flutter.dart';
import 'package:cs/repository/AuthentificationRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/screen/auth/authentication_screen.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'password_screen.dart';
class DesktopAuthentication extends StatefulWidget {
  const DesktopAuthentication({Key? key}) : super(key: key);

  @override
  State<DesktopAuthentication> createState() => _DesktopAuthenticationState();
}

class _DesktopAuthenticationState extends State<DesktopAuthentication> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var repositoryAuth = Get.put(AuthenficationRepository());

  String? imagePath;
  RoundedLoadingButtonController _controllerBounded = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  String? error;
  RoundedLoadingButtonController controllerEnd = RoundedLoadingButtonController();
  late String  message;
  final  _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));




  @override
  void initState() {
    super.initState();
    message = getRandomString(8);
    _controller = AnimationController(vsync: this);
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
        body: Row(
          children: [
            Expanded(flex : 3,child: Container(
              padding: EdgeInsets.symmetric(horizontal: 120),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        link(url:'https://cursorsdesign.com', text :  "Site web"),
                        SizedBox(width: 50,),
                        link(url:'https://cursorsdesign.com/confidentialite', text :  "Politique de confidentialité"),
                        SizedBox(width: 50,),
                        link(url:'https://www.facebook.com/cursorsdesigngroup', text :  "Facebook"),
                        SizedBox(width: 50,),
                        link(url:'https://wa.me/+2250556375765', text :  "Whatsapp"),
                        SizedBox(width: 50,),
                        link(url:'https://wa.me/+2250556375765', text :  "Aides"),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 150,
                          ),
                          Text('Gérer vos produits et ventes \navec  facilité sur votre ordinateur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,),
                          SizedBox(height: 12,),
                          Text('Authentifier vous pour beneficier de la performance de Cursors Store'),
                          SizedBox(height: 50,),
                          Form(
                            key: _formKey,
                            child: Container(
                              width: 500,
                              child: Column(
                                children: [

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
                                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
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
                          SizedBox(height: 50,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              bottomLink(url: 'https://www.facebook.com/cursorsdesigngroup', text: "Facebook", icon:Icons.facebook),
                              bottomLink(url: 'https://wa.me/+2250556375765', text: "Whatsapp", icon:Icons.messenger),
                              bottomLink(url: "https://cursorsdesign.com/android", text: "Play store", icon: Icons.play_arrow),
                              bottomLink(url: "https://cursorsdesign.com/ios", text: "Apple store", icon: Icons.apple)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
            Expanded(flex : 2,child: Container(
              width: double.infinity,
              height: double.infinity,
              child : Image.asset("assets/images/SCAN WEB.jpg", fit: BoxFit.fill,),
            ))
          ],
        ),
      ),
    );
  }


  Widget link({required String text,required String url}){
    return InkWell(
      onTap : (){
        launchInBrowser(Uri.parse(url));
      },
      child: Text(text.toUpperCase(), style: TextStyle(color: kPrimaryColor)),
    );
  }

  Widget bottomLink({required String url, required String text, required IconData icon}){
    return InkWell(
      onTap : (){
        launchInBrowser(Uri.parse(url));
      },
      child: Container(
        padding : EdgeInsets.all(12),
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(),
            color: Colors.black
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white,),
            SizedBox(width: 12,),
            Text(text.toUpperCase(), style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }

}
