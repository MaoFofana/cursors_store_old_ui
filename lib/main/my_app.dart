import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cs/model/User.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/screen/auth/authentication_screen.dart';
import 'package:cs/screen/auth/desktop_authentication.dart';
import 'package:cs/screen/auth/login_screnn.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:cs/screen/utils/globals.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState  extends State<MyApp> {
  var repository = Get.put(UserRepository());
   AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications'
  );

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }


  @override
  void initState() {
    if(GetPlatform.isMobile){
      late FirebaseMessaging messaging =  FirebaseMessaging.instance;
      messaging.getToken().then((value)async{
        if(userAuth != null){
          userAuth!.firebase = value;
          await  repository.updateUser(userAuth!);
        }
        logger.d(value);
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  icon: android?.smallIcon,
                  // other properties...
                ),
              ));
        }
      //  await _showNotification();
        logger.d(message.notification!.body);
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

    if(GetPlatform.isMobile){
     // if (!mounted) return;
      if(storage.read("user") != null){
        User user = User.fromJson(storage.read("user"));
        userAuth = user;
       return HomeScreen();
      }else {
        return LoginScreen();
      }
    }else {
      if(storage.read("user") != null){
        User user = User.fromJson(storage.read("user"));
        userAuth = user;
        return StockScreenMain();
      }else {
        return DesktopAuthentication();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        appBarTheme: appBarTheme(),
        scaffoldBackgroundColor: Colors.grey.shade50,
        textTheme: textTheme(),
        primaryColor: kPrimaryColor,
        backgroundColor: kPrimaryColor,
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
          home:home
      ),
    );
  }
}
