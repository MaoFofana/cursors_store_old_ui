import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cs/screen/auth/authentication_screen.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/screen/splash_screen.dart';
import 'package:cs/screen/utils/globals.dart';
import 'package:cs/screen/utils/route_generator.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:cs/model/User.dart' as UserAuth;
import '../screen/utils/app_theme.dart';


class MainAppIntFirebase extends StatefulWidget {
  const MainAppIntFirebase({Key? key}) : super(key: key);


  @override
  State<MainAppIntFirebase> createState() => _MainAppIntFirebaseState();
}

class _MainAppIntFirebaseState  extends State<MainAppIntFirebase> {
  late FirebaseMessaging messaging;
  @override
  void initState() {
    if(GetPlatform.isMobile){
     // FlutterNativeSplash.remove();
      messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value){;
      logger.d(value);
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        String?  token = storage.read("token");
        if(token != null){
        //  var user = User.fromJson(storage.read("user"));
          //userAuth = user;
        }else {

        }
      });
    }
    super.initState();
  }

  Widget get home {
    /// await Future.delayed(const Duration(seconds: 3));
    final isLoggedIn = Globals.firebaseUser != null;
    // if (!mounted) return;

    if(isLoggedIn && storage.read("user") != null){
      UserAuth.User user = UserAuth.User.fromJson(storage.read("user"));
      userAuth = user;
      return HomeScreen();
    }else {
      return AuthenticationScreen();
    }
  }
  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child:AdaptiveTheme(
        light: ThemeData(
          appBarTheme: appBarTheme(),
          scaffoldBackgroundColor: Colors.grey.shade50,
          textTheme: textTheme(),
          backgroundColor: Colors.white,
          inputDecorationTheme: inputDecorationTheme(kPrimaryColor),
          colorScheme: ThemeData().colorScheme.copyWith(
            primary: kPrimaryColor,
          ),
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) =>GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const  [
              Locale('fr', ''), // french
            ],
            debugShowCheckedModeBanner: false,
            title: 'CD Business',
            theme: theme,
            home: home,
            scaffoldMessengerKey: Globals.scaffoldMessengerKey,
            darkTheme: AppTheme.darkTheme,
           // onGenerateRoute: RouteGenerator.generateRoute,
            //initialRoute: SplashScreen.id,
        ),
      )
    );
  }
}