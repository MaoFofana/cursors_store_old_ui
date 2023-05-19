
import 'package:cs/components/bottom_menu.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SocialScreenMain extends StatefulWidget {
  const SocialScreenMain({Key? key}) : super(key: key);

  @override
  State<SocialScreenMain> createState() => _SocialScreenMainState();
}

class _SocialScreenMainState extends State<SocialScreenMain> with SingleTickerProviderStateMixin {
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
          title: Text("Social", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
          actions: [

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
            ],
          ),
        ),
          floatingActionButton: SpeedDial(
            backgroundColor: kPrimaryColor,
            icon: Iconsax.task_square,
            activeIcon: Icons.close,
            spaceBetweenChildren: 4,
            elevation: 8.0,
            animationCurve: Curves.elasticInOut,
            isOpenOnStart: false,
            children: [
              SpeedDialChild(
                  child:Icon(Iconsax.message),
                  label: 'Messaage',
                 /// onTap: (){Get.to(UniteScreen());}
              ),
              SpeedDialChild(
                  child: Icon(Iconsax.sms),
                  label: 'Email',
                //  onTap: (){Get.to(CategorieScreen());}
              ),
            ],
          ),
          bottomNavigationBar: BottomMenu(index: 2),
      ),
    );
  }

  Widget container(String title , String image, StatefulWidget page){
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
            Image.asset("assets/images/$image",width: 150,),
            SizedBox(height: 12,),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
