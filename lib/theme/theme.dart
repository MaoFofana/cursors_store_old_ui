
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cs/single/constant.dart';

ThemeData theme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Muli",
      appBarTheme: appBarTheme(),
      primaryColor: kPrimaryColor,
      textTheme: textTheme(),
      inputDecorationTheme: inputDecorationTheme(kPrimaryColor),
      visualDensity: VisualDensity.adaptivePlatformDensity);
}

InputDecoration noneInputDecorationCell(String hintText){
  return  InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.only(left: 15, bottom: 11, top: 5, right: 15),
      hintText: hintText);
}


// Create AppBarTheme
AppBarTheme appBarTheme() {
  return AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle.dark, toolbarTextStyle: TextTheme(
          headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18.0)).bodyText2, titleTextStyle: TextTheme(
          headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18.0)).headline6);
}

// Create TextTheme
TextTheme textTheme() {
  return const TextTheme(
      bodyText1: TextStyle(
        color: kTextColor,
      ),
      bodyText2: TextStyle(color: kTextColor,fontSize: 18));
}

InputDecorationTheme inputDecorationTheme(Color themeColor) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.black12
    ),
    borderRadius: radius,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
      fillColor: themeColor,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.only(left : 12, bottom : 10, top : 5, right: 5),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      focusColor: themeColor,
      border: outlineInputBorder,
      disabledBorder: outlineInputBorder
  );
}