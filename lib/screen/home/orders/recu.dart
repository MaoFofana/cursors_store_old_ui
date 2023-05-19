import 'dart:typed_data';

import 'package:cs/model/Order.dart';
import 'package:cs/screen/home/orders/recu_component.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';


class RecuOrder extends StatefulWidget {
  RecuOrder({Key? key, required this.order,required this.image}) : super(key: key);
  Order order;
  Uint8List? image;
  @override
  State<RecuOrder> createState() => _RecuOrderState();
}

class _RecuOrderState extends State<RecuOrder> with SingleTickerProviderStateMixin {
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
  return Scaffold(
        appBar: AppBar(
          title: Text("Commande-${widget.order.number!}"),
          centerTitle: true,
        ),
        body: PdfPreview(
          canDebug: false,
          canChangePageFormat: false,
          build: (format) => RecuComponent(widget.order,widget.image).generatePdf(format, widget.order.number!),
        )
    );
  }
}
