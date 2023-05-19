

import 'package:cs/components/bottom_menu.dart';
import 'package:cs/screen/galery/galery_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'profile/user_screen.dart';

class MenuScrennHome extends StatefulWidget {
  const MenuScrennHome({Key? key}) : super(key: key);

  @override
  State<MenuScrennHome> createState() => _MenuScrennHomeState();
}

class _MenuScrennHomeState extends State<MenuScrennHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
          automaticallyImplyLeading: false,
          title: Text("Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
          actions: [
            IconButton(onPressed: (){
              Get.to(UserScreenMain());
            }, icon: Icon(Iconsax.user,color: Colors.black,))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              container("Jeux", Iconsax.game, GaleryScreenMain()),
              container("Galeries", Iconsax.gallery, GaleryScreenMain()),
              container("Depenses", Iconsax.dollar_circle, GaleryScreenMain()),
              container("Comptabilités", Iconsax.presention_chart, GaleryScreenMain()),
            ],
          ),
        ),
        bottomNavigationBar: BottomMenu(index: 3),
      ),
    );
  }

  Widget container(String title , IconData iconData, StatefulWidget page){
    return InkWell(
      onTap: (){
        Get.to(page);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 70,),
            SizedBox(height: 12,),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
