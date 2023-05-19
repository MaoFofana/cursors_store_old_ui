

import 'dart:io';

import 'package:cs/model/Product.dart';
import 'package:cs/screen/stock/product/view_product.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProduitCard extends StatefulWidget {
  ProduitCard({Key? key,required this.product}) : super(key: key);
  Product product;
  @override
  State<ProduitCard> createState() => _ProduitCardState();
}

class _ProduitCardState extends State<ProduitCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Product product;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    setState(() {
      product = widget.product;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(ViewProduct(product: product,));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: radius,
            color: Colors.grey.shade200
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: radius,
                ),
                child:ClipRRect(
                  borderRadius: radius, // Image border
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(48), // Image radius
                    child: Image.network(product.images![0].url!, fit: BoxFit.cover),
                  ),
                )
            ),
            SizedBox(width: 12,),
            Expanded(child:  Container(
              margin: EdgeInsets.all(0),
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name!,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14), maxLines: 2,),
                  SizedBox(height: 3,),
                  //Icon(Iconsax.scan_barcode),
                  Text(product.code!,style: TextStyle(fontSize: 13))
                ],
              ),
            ))
            ,
            SizedBox(width: 12,),
            Container(
              height: 75,
              padding: EdgeInsets.only(top: 12),
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                decoration: BoxDecoration(
                    borderRadius: radius,
                    color: kPrimaryColor
                ),
                child:Text("${product.quantity!} x ${product.price.toString().replaceAll(".0", "")} F",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
