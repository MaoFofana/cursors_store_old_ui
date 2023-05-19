import 'package:cs/model/Product.dart';
import 'package:cs/model/Stock.dart';
import 'package:cs/repository/StockRepository.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import 'component/rapport_pdf_stock.dart';
import 'component/rapport_pdf_vente.dart';


class RapportScreen extends StatefulWidget {
  RapportScreen({Key? key, required this.start , required this.end , this.product}) : super(key: key);
  DateTime start;
  DateTime end;
  Product? product;
  @override
  State<RapportScreen> createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Stock> stocks = [];
  var stockRepository = Get.put(StockRepository());
  int quantiteEntree = 0;
  int quantiteSortie = 0;
  int quantiteStock = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init();
  }

  _init() async{
    widget.start.subtract(Duration(days: 1));
    widget.end.add(Duration(days: 1));
     if(widget.product == null){

       var response = await stockRepository.getByPeriode(widget.start.millisecondsSinceEpoch.toString(), widget.end.millisecondsSinceEpoch.toString());
       if(response.statusCode == 200){
         logger.d(response.statusCode);
         logger.d(response.body!);
         setState(() {
           stocks.addAll(response.body!);
         });
       }else {
         logger.d(response.statusCode);
       }
     }else {
       var response = await stockRepository.getByPeriodeAndProduct(widget.start.millisecondsSinceEpoch.toString(), widget.end.millisecondsSinceEpoch.toString(), widget.product!.id!);
       if(response.statusCode == 200){
         setState(() {
           stocks.addAll(response.body!);
         });
       }
     }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Rapport"),
              centerTitle: true,
                bottom :TabBar(
                  tabs: [
                    Tab(child: Text("Stock", style: TextStyle(color: kPrimaryColor),),),
                    Tab(child: Text("Vente", style: TextStyle(color: kPrimaryColor),),)
                  ],
                )
            ),
            body:TabBarView(
              children: [
                PdfPreview(
                  canDebug: false,
                  canChangePageFormat: false,
                  build: (format) => RapportPdfStock(stocks,start : widget.start, end: widget.end, product: widget.product).generatePdf(format),
                ),
                PdfPreview(
                  canDebug: false,
                  canChangePageFormat: false,
                  build: (format) => RapportPdfVente(stocks.where((element) => element.quantityEntree == null || element.quantityEntree! == 0).toList(),start : widget.start, end: widget.end, product: widget.product).generatePdf(format),
                )
              ],
            )
        )
    );
  }
}
