

import 'package:cs/single/constant.dart';
import 'package:flutter/cupertino.dart';

Widget title(double size){
  return RichText(
    // Controls how the text should be aligned horizontally
    textAlign: TextAlign.center,
    // Control the text direction
    textDirection: TextDirection.rtl,
    text: TextSpan(
      style: TextStyle(fontSize: size),
      children: const <TextSpan>[
        TextSpan(
            text: 'Cursor', style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
        TextSpan(
            text: 'Store', style: TextStyle(fontWeight: FontWeight.bold, color: kSecondaryColor)),
      ],
    ),
  );
}