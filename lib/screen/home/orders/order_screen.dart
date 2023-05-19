import 'package:cs/components/table.dart';
import 'package:cs/model/Order.dart';
import 'package:cs/repository/OrderRepository.dart';
import 'package:cs/screen/home/orders/create_order.dart';
import 'package:cs/screen/home/orders/show_order_screen.dart';
import 'package:cs/screen/stock/stock_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Order> orders = [];
  var repository = Get.put(OrderRepository());
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init();
  }

  _init() async{
      var response = await repository.getAll();
      logger.d(response.body!);
      if(response.statusCode == 200){
        setState(() {
          orders.addAll(response.body!);
        });
      }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Liste des commandes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),),
          actions: [
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TableData(
                    loading: false,
                    columns: [
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Nom du client")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Actions")),
                    ], rows: [
                  ...List.generate(orders.length, (index) => DataRow(cells: [
                    DataCell(Text(dateConvert(orders[index].createdAt!))),
                    DataCell(Text(orders[index].clientName ?? "")),
                    DataCell(Text(orders[index].status ?? "")),
                    DataCell(Row(children: [
                      IconButton(onPressed: (){
                        Get.to(ShowOrderScreen(),arguments: orders[index]);
                      }, icon: Icon(Iconsax.eye, color: Colors.green,)),
                      if(orders[index].status == livraisonsStatus.first)
                      IconButton(onPressed: (){
                        Get.to(CreateOrderScreen(order:orders[index]));
                      }, icon: Icon(Iconsax.edit_2, color: Colors.blue,)),
                      if(orders[index].status == livraisonsStatus.first)
                      IconButton(onPressed: (){
                        Get.defaultDialog(
                          radius: roundedValue,
                          middleText: "",
                          title: "Vous-voulez vous \anuller ${orders[index].number!}",
                          cancel: TextButton(onPressed: (){
                            Get.close(1);
                          }, child: Text("Non", style: TextStyle(color: danger),)),
                          confirm: TextButton(onPressed: () async{
                            setState(() {
                              orders[index].status = livraisonsStatus.last;
                              repository.updateOrder(orders[index]);
                            });
                            Get.close(1);
                          }, child: Text('Oui')),
                          cancelTextColor: danger,
                          confirmTextColor:  Colors.white,

                        );
                      }, icon: Icon(Iconsax.trash, color: danger,))
                    ],))
                  ]))
                ])
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: Icon(Iconsax.add),
          onPressed: (){
            Get.to(CreateOrderScreen());
          },
        ),
      ),
    ), onWillPop: (){
      Get.to(StockScreenMain());
      return Future.value(true);
    });
  }
}
