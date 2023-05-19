import 'package:cs/components/button.dart';
import 'package:cs/model/Order.dart';
import 'package:cs/repository/OrderRepository.dart';
import 'package:cs/screen/home/orders/order_screen.dart';
import 'package:cs/screen/home/orders/recu.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ShowOrderScreen extends StatefulWidget {
   ShowOrderScreen({Key? key}) : super(key: key);

  @override
  State<ShowOrderScreen> createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Order order;
  Uint8List? image;
  var repository = Get.put(OrderRepository());
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init();
  }

  _init()async{
   // var image = (await rootBundle.load('assets/images/logo.jpeg')).buffer.asUint8List();
    setState(() {
      order = Get.arguments;
     // this.image = image;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget? get bottom {
    if(order.status == livraisonsStatus[1]){
      return Container(
        padding: EdgeInsets.all(15),
        child: DefaultButton(text: 'Imprimer',press: (){
        Get.to(RecuOrder(order: order, image: image));
      },)
      );
    }else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Commande"),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text("Commande ${order.number!}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: 12,),
                Text("Informations".toUpperCase(), style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),),
                Container(
                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nom et prénom"),
                      Text(order.clientName ?? '')
                    ],
                  ),
                ),
                Container(
                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Adresse"),
                      Text(order.lieu ?? '')
                    ],
                  ),
                ),
                Container(
                  padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Contact"),
                      Text(order.clientNumber ?? '')
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Status de la commande".toUpperCase(), style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
                if(order.status == livraisonsStatus.first)
                  Text('(Cocher le status de la commande)', style: TextStyle()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[ //SizedBox
                    Text(
                      'Commande non livrée'.toUpperCase(),
                      style: TextStyle(fontSize: 17.0),
                    ), //TextSizedBox
                    Checkbox(
                      activeColor: Colors.green,
                      value: order.status == livraisonsStatus.first,
                      onChanged: (bool? value) {
                        setState(() {
                          if(value == true &&  order.status  == livraisonsStatus.first){
                            order.status = livraisonsStatus.last;
                            repository.updateOrder(order);
                          }
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Commande  livrée'.toUpperCase(),
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      activeColor: Colors.green,
                      value: order.status == livraisonsStatus[1],
                      onChanged: (bool? value) {
                        setState(() {
                          if(value == true &&  order.status  == livraisonsStatus.first){
                            order.status = livraisonsStatus[1];
                            repository.updateOrder(order);
                          }
                        });
                      },
                    ), //Checkbox
                  ], //<Widget>[]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Commande anuller'.toUpperCase(),
                      style: TextStyle(fontSize: 17.0),
                    ),
                    Checkbox(
                      activeColor: Colors.green,
                      value: order.status == livraisonsStatus.last,
                      onChanged: (bool? value) {
                        setState(() {
                          if(value == true &&  order.status == livraisonsStatus.first){
                            order.status = livraisonsStatus.last;
                            repository.updateOrder(order);
                          }
                        });
                      },
                    ), //Checkbox
                  ], //<Widget>[]
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Liste des produits".toUpperCase(), style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
                SizedBox(height: 12,),
                ...List.generate(order.panierProducts!.length,
                        (index) =>  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${order.panierProducts![index].quantite}x ${order.panierProducts![index].name}"),
                              Text("${(order.panierProducts![index].quantite! * order.panierProducts![index].price!).toString().replaceAll(".0", "")} F"),
                            ],
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1.0,
                      ))
                  ),
                ),
                SizedBox(height: 15,),
                Text("Récapitulatifs".toUpperCase(), style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sous-total"),
                    Text("${order.discountTotal!.toString().replaceAll(".0", "")} F")
                  ],
                ),
                if(order.status == livraisonsStatus.first)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Avance"),
                      Text(order.avance != null  ? "${order.avance!.toString().replaceAll(".0", "")} F" : "0F")
                    ],
                  ),
                if(order.status == livraisonsStatus.first)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Reste"),
                      Text((order.total! - order.avance!).toString() + " F")
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Frais de Livraion"),
                    Text(order.shippingTotal!.toString().replaceAll(".0", "") + " F")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total"),
                    Text("${order.total.toString().replaceAll(".0", "")} F")
                  ],

                ),
                if(order.status == livraisonsStatus.first)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Reste à payer"),
                      Text((order.total! - (order.avance ?? 0)).toString() + " F")
                    ],
                  ),
              ],
            ),
          ),
          bottomNavigationBar: bottom,
        )
        , onWillPop: (){
          Get.to(OrderScreen());
          return Future.value(true);
    });
  }
}
