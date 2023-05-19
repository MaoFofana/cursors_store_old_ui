import 'package:cs/model/User.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

const kPrimaryColor = Color.fromRGBO(9, 76, 146, 1);
const kPrimaryLightColor = Color.fromRGBO(15, 111, 211, 1.0);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color.fromRGBO(9, 76, 146, 1),Color(0xFF0EA4EE)],
);
const kSecondaryColor = Color.fromRGBO(202, 149, 35, 1);
const kTextColor = Color.fromRGBO(29, 29, 29, 1);

const kAnimationDuration = Duration(milliseconds: 200);
const defaultPadding = 8.0;
const roundedValue = 8.0 ;
var radius = const BorderRadius.all(Radius.circular(roundedValue));

var SUPER_ADMIN = "SUPER_ADMIN";
var USER = "USER";
var LIVREUR = "LIVREUR";

var baseUrlConst ="$baseUrl";
var baseUrl = "http://api.cursorsdesign.com/"; //"http://localhost:3333";// "http://192.168.1.66:3333";//
var baseUrlSocket ="http://store.cursorsdesign.com:8080"; //"ws://localhost:3333";//"http://192.168.1.66:3333";//
User? userAuth;

String convertDate(DateTime date){
  return "${date.day}/${date.month}/${date.year}";
}

Map<String,String>  get headeConst{
  String? token = storage.read('token');
  Map<String,String> headear =  {"Authorization" : "Bearer $token"};
  return headear;
}

GetStorage storage = GetStorage('CDBusiness');
var logger = Logger();

String dateConvert(DateTime date){
  return "${date.day}/${date.month}/${date.year}";
}

var livraisonsStatus = ["PAS LIVREE" , "LIVREE", "ANULLER"];

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
