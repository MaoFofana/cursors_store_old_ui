
import 'dart:typed_data';

import 'package:cs/single/constant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../model/Order.dart';

class RecuComponent {
  RecuComponent(this.order, this.image);
  Order order;
  Uint8List? image;
  Future<Uint8List> generatePdf(PdfPageFormat format, String title) async {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Facture N°${order.number!}", style: TextStyle(fontWeight: FontWeight.bold)),
             // Image(MemoryImage(image),width: 120, height: 120)
            ]
        ),
        SizedBox(height: 12),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userAuth!.name ?? "",style: TextStyle(fontWeight: FontWeight.bold) ),
                Text(userAuth!.adresse ?? ""),
                Text(userAuth!.phone ?? ""),
                Text(userAuth!.email ?? "")
              ]
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Client",style: TextStyle(fontWeight: FontWeight.bold)),
                Text(order.clientName ?? ''),
                Text(order.lieu ?? ''),
                Text(order.clientNumber ?? ' '),
              ]
            )
          ]
        ),
        SizedBox(height: 12),
        Table(
          border: TableBorder.all(width: 0.2),
          children: [
            TableRow(
                children: [
              Container(
                padding: EdgeInsets.all(2),
                child: Text('Nom'))  ,
              Container(
                  child: Text('Quantité')
              ),
              Container(
                  child: Text('Prix')
              ),
              Container(
                  child: Text('Total')
              ),
            ]),
            ...List.generate(order.panierProducts!.length, (index) =>
                TableRow(children: [
                  Container(
                      child: Text(order.panierProducts![index].name!)
                  )  ,
                  Container(
                      child: Text(order.panierProducts![index].quantite!.toString(), textAlign: TextAlign.right)
                  ),
                  Container(
                      child: Text(order.panierProducts![index].price!.toString(), textAlign: TextAlign.right)
                  ),
                  Container(
                      child: Text((order.panierProducts![index].price! * order.panierProducts![index].quantite!).toString(), textAlign: TextAlign.right)
                  ),
                ]))
          ]
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Text(''),flex: 3),
            Expanded(
                child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("Sous-total"), flex: 3),
                          Expanded(child: Text(":"), flex: 1),
                          Expanded(child: Text(" ${order.discountTotal!.toString().replaceAll(".0", "")} FCFA", textAlign: TextAlign.right), flex: 3),
                        ]
                      ),
                      SizedBox(height: 3),
                      Row(
                          children: [
                            Expanded(child: Text("Livraison"), flex: 3),
                            Expanded(child: Text(":"), flex: 1),
                            Expanded(child: Text(" ${order.shippingTotal!.toString().replaceAll(".0", "")} FCFA", textAlign: TextAlign.right), flex: 3),
                          ]
                      ),
                      SizedBox(height: 3),
                     Container(
                       decoration: BoxDecoration(
                         border: Border(top: BorderSide(width: 0.2))
                       ),
                       child:  Row(
                           children: [
                             Expanded(child: Text("Total"), flex: 3),
                             Expanded(child: Text(":"), flex: 1),
                             Expanded(child: Text(" ${order.total!.toString().replaceAll(".0", "")} FCFA", textAlign: TextAlign.right), flex: 3),
                           ]
                       ),
                     )
                    ]
                ), flex: 2)

          ]
        )
      ])
    );
    return pdf.save();
  }
}