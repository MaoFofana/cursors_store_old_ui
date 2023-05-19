import 'package:cs/model/User.dart';
import 'package:cs/repository/AuthentificationRepository.dart';
import 'package:cs/screen/auth/desktop_authentication.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var authenticationRepository = Get.put(AuthenficationRepository());
  @override
  void initState() {
    (() async {
      if(GetPlatform.isAndroid || GetPlatform.isIOS){
      }else {
        await Future.delayed(const Duration(seconds: 3));
        if(storage.read("user") != null){
          User user = User.fromJson(storage.read("user"));
          userAuth = user;
          Get.to(StockScreenMain());
        }else {
            Get.to(DesktopAuthentication());
        }
      }

    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [
            Container(
              height:Get.size.height,
              width: Get.size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(image:AssetImage('assets/images/splash.jpeg'),fit:BoxFit.fill),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Faciliter votre vie")],
                ),
              ) ,
            )
          ],
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
