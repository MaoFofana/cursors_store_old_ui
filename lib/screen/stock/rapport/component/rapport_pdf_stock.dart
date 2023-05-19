


import 'dart:typed_data';
import 'package:cs/model/Product.dart';
import 'package:cs/model/Stock.dart';
import 'package:cs/single/constant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';


class RapportPdfStock {
  RapportPdfStock(this.stocks, {this.start,this.end, this.product});
  List<Stock> stocks;
  DateTime? start;
  DateTime? end;
  Product? product;
  int quantiteEntree = 0;
  int quantiteSortie = 0;
  int quantiteStock = 0;

  Text header(String text){
    return   Text(text.toUpperCase(), style:TextStyle(fontSize: 6, fontWeight: FontWeight.bold), textAlign: TextAlign.center);
  }

  Text textNumber(String text){
    return   Text(text, style:TextStyle(fontSize: 6), textAlign: TextAlign.right);
  }

  Text textDate(String text){
    return   Text(text, style:TextStyle(fontSize: 6), textAlign: TextAlign.center);
  }

  Text textString(String text){
    return   Text(text, style:TextStyle(fontSize: 6), textAlign: TextAlign.left);
  }

  Future<Uint8List> generatePdf(PdfPageFormat format) async {
    for(var stock in stocks){
      quantiteEntree += (stock.quantityEntree ?? 0);
      quantiteSortie += (stock.quantitySortie ?? 0);
    }
    if(product != null){
      quantiteStock = stocks.last.quantite ?? 0;
    }else {
      quantiteStock = (quantiteEntree - quantiteSortie).abs();
    }
    String title = "";
    if(start != null  && end != null && product == null) {
      title = "Fiche de stock du \n${convertDate(start!)} au  ${convertDate(end!)}".toUpperCase();
    }
    if(product != null && start == null  && end == null) {
      title = "Fiche de stock de \n${product!.name}".toUpperCase();
    }

    if(product != null && start != null  && end != null) {
      title = "Fiche de stock de \n${product!.name} du ${convertDate(start!)} au  ${convertDate(end!)}".toUpperCase();
    }
    if(product == null && start == null  && end == null) {
      title = "Fiche de stock".toUpperCase();
    }

    final pdf = Document(title: title);
    pdf.addPage(
        MultiPage(
            pageTheme: PageTheme(margin: EdgeInsets.only(bottom: 8,top: 30,right: 30,left: 30)),
            footer: (context) => Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("", )
                    ]
                )
            ),
            build: (context) =>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ]
              ),
              SizedBox(height: 12),
              Table(
                  border: TableBorder.all(width: 0.2),
                  children: [
                    TableRow(
                        children: [
                          Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child:header('Dates'))  ,
                          Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: header('Code')
                          ),
                          Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: header('Désignation')
                          ),
                          Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: header('Prix')
                          ),
                          Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: header('Etrée')
                          ),
                          Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: header('Sortie')
                          ),
                          Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: header('Stock final')
                          ),
                        ]
                    ),
                    ...List.generate(stocks.length, (index) =>
                        TableRow(children: [
                          Container(
                              width: 50,
                              padding: EdgeInsets.all(5),
                              child: textDate(convertDate(stocks[index].createdAt!))
                          )  ,
                          Container(
                              width: 70,
                              padding: EdgeInsets.all(5),
                              child: textString(stocks[index].product!.code!)
                          ),
                          Container(
                              width: 150,
                              padding: EdgeInsets.all(5),
                              child: textString(stocks[index].product!.name!)
                          ),
                          Container(
                            width: 60,
                            padding: EdgeInsets.all(5),
                            child: textNumber("${(stocks[index].product!.price!).toString().replaceAll(".0", "")} FCFA"),
                          ),
                          Container(
                              width: 60,
                              padding: EdgeInsets.all(5),
                              child: textNumber(stocks[index].quantityEntree != null ? stocks[index].quantityEntree!.toString() : '')
                          ),
                          Container(
                              width: 60,
                              padding: EdgeInsets.all(5),
                              child: textNumber(stocks[index].quantitySortie != null ?stocks[index].quantitySortie!.toString() :  "")
                          ),
                          Container(
                              width: 60,
                              height: 12,
                              padding: EdgeInsets.all(5),
                              child: textNumber(stocks[index].quantite != null ?stocks[index].quantite!.toString() :  "0")
                          ),

                        ])),
                  ]
              ),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide( width: 0.2),
                            right: BorderSide( width: 0.2),
                            bottom: BorderSide( width: 0.2),

                        ),
                      ),
                      width: 346.3,
                      padding: EdgeInsets.all(5),
                      child:header("Total")
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide( width: 0.2),
                        bottom: BorderSide( width: 0.2),
                      ),
                    ),
                    padding: EdgeInsets.all(5),
                    width: 63,
                    child: textNumber(quantiteEntree.toString() ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide( width: 0.2),
                        bottom: BorderSide( width: 0.2),
                      ),
                    ),
                    padding: EdgeInsets.all(5),
                    width: 63,
                    child: textNumber(quantiteSortie.toString()),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide( width: 0.2),
                        bottom: BorderSide( width: 0.2),

                      ),
                    ),
                    width: 63,
                    padding: EdgeInsets.all(5),
                    child: textNumber(quantiteStock.toString()),
                  )
                ]
              )
              /*  SizedBox(height: 12),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: Text(''),flex: 3),
                    Expanded(
                        child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Total vente :"),
                                    Text(" ${total.toString().replaceAll(".0", "")} FCFA", textAlign: TextAlign.right)
                                  ]
                              )
                            ]
                        ), flex: 2)

                  ]
              )*/
            ])
    );
    return pdf.save();
  }
}