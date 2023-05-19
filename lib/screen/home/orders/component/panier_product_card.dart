


import 'dart:io';

import 'package:cs/model/PanierProduct.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/screen/stock/product/view_product.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PanierProductCard extends StatefulWidget {
  PanierProductCard({Key? key,required this.item, required this.delete}) : super(key: key);
  PanierProduct item;
  Function delete;
  @override
  State<PanierProductCard> createState() => _PanierProductCardState();
}

class _PanierProductCardState extends State<PanierProductCard> with SingleTickerProviderStateMixin {
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
      width: double.infinity,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: radius,
          color: Colors.grey.shade50
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
                  child: widget.item.image != null ? Image.network(widget.item.image!, fit: BoxFit.cover) : Image.asset("", fit: BoxFit.cover),
                ),
              )
          ),
          SizedBox(width: 12,),
          Expanded(child:  Container(
            margin: EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.item.name!,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16)),
                    IconButton(onPressed: (){
                      widget.delete();
                    }, icon: Icon(Iconsax.trash, color: Colors.red,))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding : EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration : BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius:  radius
                      ),
                      child:  Text("${widget.item.quantite} x ${widget.item.price.toString().replaceAll(".0", "")} F", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap : (){
                            setState(() {
                              var count = widget.item.quantite!;
                              count -= 1;
                              widget.item.quantite = count;
                            });
                          },
                          child: ClipOval(
                            child:Container(
                              color: kPrimaryColor,
                              child:  SizedBox.fromSize(
                                size: Size.fromRadius(9), // Image radius
                                child:Icon( Iconsax.minus, color: Colors.white,size: 16,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12,),
                        Text( widget.item.quantite!.toString()),
                        SizedBox(width: 12,),
                        InkWell(
                          onTap : (){
                            setState(() {
                              var count = widget.item.quantite!;
                              count += 1;
                              widget.item.quantite = count;
                            });
                          },
                          child: ClipOval(
                            child:Container(
                              color: kPrimaryColor,
                              child:  SizedBox.fromSize(
                                size: Size.fromRadius(9), // Image radius
                                child:Icon( Iconsax.add, color: Colors.white,size: 16,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )


                  ],
                )
                //Icon(Iconsax.scan_barcode),
                //Text(widget.item.code!)
              ],
            ),
          ))
        ],
      ),
    );
  }
}
