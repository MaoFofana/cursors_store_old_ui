import 'package:cs/screen/galery/galery_screen.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/screen/menu/menu_screen.dart';
import 'package:cs/screen/social/social_screen.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../single/constant.dart';
class BottomMenu extends StatefulWidget {
  BottomMenu({Key? key, required this.index}) : super(key: key);
  int index;
  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> with SingleTickerProviderStateMixin {
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
    return FloatingNavbar(
      backgroundColor: kPrimaryColor,
      onTap: (int val) {
        if(val == 1){
          Get.to(const StockScreenMain());
        }/*else if(val == 2){
          Get.to(const SocialScreenMain());

        }else if(val == 3){
          Get.to(const MenuScrennHome());
        }*/else {
          Get.to(const HomeScreen());
        }
        //returns tab id which is user tapped
      },
      currentIndex: widget.index,
      items: [
        FloatingNavbarItem(icon: Iconsax.home_1, title: 'Acceuil'),
        FloatingNavbarItem(icon: Iconsax.shop, title: 'Boutique'),/*
        FloatingNavbarItem(icon: Iconsax.status_up, title: 'Social'),
        FloatingNavbarItem(icon: Iconsax.grid_3, title: 'Menu'),*/
      ],
    );
  }
}
