import 'dart:io';

import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/components/title.dart';
import 'package:cs/model/User.dart';
import 'package:cs/repository/AuthentificationRepository.dart';
import 'package:cs/repository/FileRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/screen/auth/login_screnn.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class AuthenticationScreen extends StatefulWidget {

  const AuthenticationScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String? phoneNumber;
  TextEditingController nameController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var repository = Get.put(UserRepository());
  var repositoryAuth = Get.put(AuthenficationRepository());
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
          title: Text("Inscription", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.grey.shade100,
        ),
        backgroundColor:Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: send == true ? Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.clipboard_tick, color:  Colors.green,size: 50,),
                SizedBox(height: 12,),
                Text('Enregistremennt effectuer avec succes. Veuillez verifier votre boite mail pour valider votre compte',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
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
                      title(40),
                      SizedBox(height: 10,),
                      Text("Inscrivez-vous en entrant les informations de votre \nentreprise/business",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey.shade700),),
                      SizedBox(height: 50,),
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
                            child:  CircleAvatar(
                              radius: 70,
                              backgroundImage:FileImage(File(imagePath ?? "")) ,
                            ),
                          ) ,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("Cliquez sur le cercle pour \nselectionnez votre logo",textAlign: TextAlign.center,style: TextStyle(color: Colors.grey.shade700),),
                      SizedBox(height: 12,),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: "Entrer le nom de votre entreprise/business"
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Le nom de l'entreprise est obligatoire";
                          }
                          return  null;
                        },
                      ),
                      SizedBox(height: 12,),
                      TextFormField(
                        controller: adresseController,
                        decoration: InputDecoration(
                            hintText: "Entrer une localisation "
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "La localisation est obligatoire";
                          }
                          return  null;
                        },
                      ),
                      SizedBox(height: 12,),
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
                      IntlPhoneField(
                        controller: phoneController,
                        flagsButtonMargin: EdgeInsets.symmetric(horizontal: 12),
                        invalidNumberMessage: 'Numéro incorrect!',
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (phone) => phoneNumber = phone.completeNumber,
                        initialCountryCode: 'CI',
                        flagsButtonPadding: const EdgeInsets.only(right: 10),
                        showDropdownIcon: false,
                        keyboardType: TextInputType.phone,
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
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Confirmer votre mot de passe"
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "La confirmation du mot de passe est obligatoire";
                          }else if(value != passwordController.text){
                            return "La confirmation du mot de passe est incorect";
                          }
                          return  null;
                        },
                      ),
                      SizedBox(height: 12,),
                      if(error != null)
                        Text(error!, style: TextStyle(color: danger,fontSize: 15),),
                      if(error != null)
                        SizedBox(height: 12,),
                      RoundedLoadingButton(
                          controller: _controllerBounded,
                          child: Text("S'inscrire".toUpperCase()), onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          var user = User();
                          if(imagePath != null ){
                            var  fileRepository = Get.put(FileRepository());
                            var imageResponse  =await fileRepository.save(File(imagePath!).readAsBytesSync());
                            var url = imageResponse.body["name"];
                            user.avatarUrl = url;
                          }
                          user.name = nameController.text;
                          user.adresse = adresseController.text;
                          user.email = emailController.text;
                          user.password = passwordController.text;
                          user.phone = phoneNumber;
                          user.role = USER;
                          logger.d(user.toJson());
                          var response = await repositoryAuth.register(user.toJson());
                          if(response.statusCode == 200){
                            _controllerBounded.reset();
                            setState(() {
                              send = true;
                            });
                          }else {
                            _controllerBounded.reset();
                            setState(() {
                              error = response.bodyString;// "Une erreur est apparue";
                              logger.d(error);
                              logger.d(response.headers);
                            });
                            /*await Future.delayed(Duration(seconds: 5));
                            setState(() {
                              error = null;
                            });*/
                          }
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
