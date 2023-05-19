

import 'dart:io';

import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';

class CategorieCard extends StatefulWidget {
  CategorieCard({Key? key,required this.title,required this.counter,required this.image}) : super(key: key);
  String title;
  String counter;
  String image;
  @override
  State<CategorieCard> createState() => _CategorieCardState();
}

class _CategorieCardState extends State<CategorieCard> with SingleTickerProviderStateMixin {
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
    return Container(
      width: 160,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Colors.grey.shade300
      ),
      child: Column(
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
                borderRadius: radius,
            ),
            child:CircleAvatar(
              radius: 48, // Image radius
              backgroundImage: FileImage(File(widget.image)),
            )
          ),
          SizedBox(height: 12,),
           Text(widget.title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),textAlign: TextAlign.center,),
          SizedBox(height: 12,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: radius,
              color: kPrimaryColor
            ),
            child: Text(widget.counter, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }
}
