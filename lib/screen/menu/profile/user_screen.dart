
import 'dart:io';

import 'package:cs/repository/FileRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';

import 'components/information_container.dart';

class UserScreenMain extends StatefulWidget {
  const UserScreenMain({Key? key}) : super(key: key);

  @override
  State<UserScreenMain> createState() => _UserScreenMainState();
}

class _UserScreenMainState extends State<UserScreenMain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var  userRepository = Get.put(UserRepository());
  var  fileRepository = Get.put(FileRepository());
  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(
          title: Text("Mes informations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png'],
                  );
                  if (result != null) {

                    var imageResponse  =await fileRepository.save(File(result.files.single.path!).readAsBytesSync());
                    setState(() {
                      userAuth!.avatarUrl =  imageResponse.body["name"];
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
                    child: userAuth!.avatarUrl == null ?
                    const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ) :
                    CircleAvatar(
                      radius: 70,
                      backgroundImage:NetworkImage(userAuth!.avatarUrl!),
                    ),
                  ) ,
                ),
              ),
              SizedBox(height: 12,),
              InformationContainer(
                icon:  Iconsax.user,
                label:"Nom ", information: userAuth!.name, update: (String value){
                userAuth!.name = value;
                userRepository.updateUser(userAuth!);
              },hint:  "Modifier votre nom",),
              Divider(),
              InformationContainer(
                icon: Iconsax.call,
                  label:"Contact", information: userAuth!.phone!, update: (String value){
                  userAuth!.phone = value;
                  userRepository.updateUser(userAuth!);
              },active:  false),
              Divider(),
              InformationContainer(
                icon: Icons.alternate_email_outlined,
                  label:"Email", information: userAuth!.email, update: (String value){
                userAuth!.email = value;
                userRepository.updateUser(userAuth!);
              }, hint: "Modifier votre email"),
              Divider(),
              InformationContainer(
                  icon: Iconsax.map,
                  label:"Adresse", information: userAuth!.email, update: (String value){
                userAuth!.email = value;
                userRepository.updateUser(userAuth!);
              }, hint: "Modifier votre adresse"),
            ]
          ),
        ),
      ),
    );
  }
}
