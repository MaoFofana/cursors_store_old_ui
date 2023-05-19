import 'package:cs/screen/auth/desktop_authentication.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/screen/stock/categories/categorie_screen.dart';
import 'package:cs/screen/stock/magasin/magasin_screen.dart';
import 'package:cs/screen/stock/product/add_product.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:cs/screen/stock/unites/unite_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../screen/stock/rapport/component/rapport_select_modal.dart';

class DashboardLayout extends StatefulWidget {
  DashboardLayout({Key? key, required this.child, this.icon,  this.title, this.rightMenu}) : super(key: key);
  Widget child;
  String? title;
  IconData? icon;
  Widget? rightMenu;
  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> with SingleTickerProviderStateMixin {
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

  ListTile DrawerChild(String title, IconData icon, Widget nextPage){
    return ListTile(
  //    hoverColor: Colors.white,
      leading: Icon(icon, color: Colors.black,),
      title: Text(title,),
      onTap: (){
        Get.to(nextPage);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 1,
          automaticallyImplyLeading: false,
          title: Text("Cursors Design Business", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
          actions: [
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(width: 0.2 ,color: kPrimaryColor)
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: kPrimaryLightColor,
                    child: Padding(
                      padding: const EdgeInsets.all(1), // Border radius
                      child: Icon(Iconsax.user, color: Colors.white,),
                    ),
                  ),
                  Text(userAuth!.phone!,style: TextStyle(color: Colors.black),)
                ],
              ),
            )
          /*  IconButton(onPressed: (){
              //  Get.to(OrderScreen());
            }, icon: Icon(Iconsax.notification,color: Colors.black,)),*/
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child:Drawer (
                elevation: 0,
              //  backgroundColor: kPrimaryColor,
                child:Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 0.2)
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          DrawerChild("Voir les produits", Iconsax.eye, StockScreenMain()),
                          DrawerChild("Ajouter un produit", Iconsax.add, AddProduct()),
                          DrawerChild("Categories", Iconsax.box, CategorieScreen()),
                          DrawerChild("Unites", Iconsax.directbox_notif, UniteScreen()),
                          DrawerChild("Magasins", Iconsax.home_hashtag, MagasinScreen()),
                          ListTile(
                            leading: Icon( Iconsax.activity, color: Colors.black,),
                            title: Text("Rapports"),
                            onTap: (){
                              Get.dialog(RapportSelectModal());
                            },
                          )
                        ],
                      ),
                      ListTile(
                        leading: Icon( Iconsax.logout, color: Colors.red,),
                        title: Text("Deconnection", style: TextStyle(color: Colors.red),),
                        onTap: (){
                          storage.erase();
                          Get.dialog(DesktopAuthentication());
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
                child: Container(
                  color: Colors.grey.shade100,
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(12),
                  child: (widget.icon != null && widget.rightMenu != null && widget.title != null)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child:  Row(
                              children: [
                                Icon(widget.icon, size: 30, color: kPrimaryColor,),
                                SizedBox(width: 12,),
                                Text(widget.title ?? '', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),)
                              ],
                            ),
                          ),
                          if(widget.rightMenu != null)
                          Expanded(
                            child:widget.rightMenu!,
                          )
                        ],
                      ),
                      SizedBox(height: 12,),
                      widget.child
                    ],
                  ) :
                  widget.child,)
            )
          ],
        ),
      ),
    );
  }
}
