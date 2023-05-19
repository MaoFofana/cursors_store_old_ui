import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/components/text_product_filtre.dart';
import 'package:cs/model/Order.dart';
import 'package:cs/model/PanierProduct.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/repository/OrderRepository.dart';
import 'package:cs/screen/home/orders/component/panier_product_card.dart';
import 'package:cs/screen/home/orders/order_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CreateOrderScreen extends StatefulWidget {
  CreateOrderScreen({Key? key,this.order}) : super(key: key);
  Order? order;
  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  TextEditingController clientName = TextEditingController();
  TextEditingController clientNumber = TextEditingController();
  TextEditingController clientAvance = TextEditingController();
  TextEditingController lieuLivraison = TextEditingController();
  TextEditingController prixLivraison = TextEditingController();
  bool save = false;
  List<PanierProduct> panier = [];
  Order order = Order();
  var orderRepository = Get.put(OrderRepository());
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    if(widget.order != null){
      order = widget.order!;
      clientNumber.text = order.clientNumber != null ? order.clientNumber.toString().replaceAll("+225", "") : "";
      clientName.text = order.clientName ?? "";
      clientAvance.text = order.avance != null ? order.avance!.toString() :  "";
      lieuLivraison.text  = order.lieu ?? "";
      prixLivraison.text = order.shippingTotal  != null ? order.shippingTotal!.toString() : "";
      panier = order.panierProducts ?? [];
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Nouvelle commande", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),),
          actions: [

          ],
        ),
        body: save == true
        ?
        Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Iconsax.clipboard_tick, color: Colors.green,size: 150,),
              SizedBox(height: 12,),
              Text("Commande enregistrer avec succes", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(child: DefaultButton(text: "Terminer", press: (){
                    Get.to(OrderScreen());
                  },color: danger,)),
                  SizedBox(width: 12,),
                  Expanded(child: DefaultButton(text: "Ajouter", press: (){
                    clientName.text = "";
                    clientNumber.text = "";
                    clientAvance.text = "";
                    lieuLivraison.text = "";
                    prixLivraison.text = "";
                    setState(() {
                      order  = Order();
                      panier.clear();
                      save = false;
                    });
                  },)),
                ],
              )
            ],
          ),
        ):
        SingleChildScrollView(
          child:  Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 12,),
                      Text("Entrer les informations de la commande",textAlign: TextAlign.center,),
                      SizedBox(height: 12,),
                      TextFormField(
                        controller: clientName,
                        decoration: InputDecoration(
                            hintText: "Entrer le nom du clients"
                        ),
                        onChanged: (String nom){
                          setState(() {
                            order.clientName = nom;
                          });
                        },
                      ),
                      SizedBox(height: 12,),
                      IntlPhoneField(
                        controller: clientNumber,
                        flagsButtonMargin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: InputDecoration(
                            hintText: "Ajouter son contact",hintStyle: TextStyle(fontSize: 17)
                        ),
                        invalidNumberMessage: 'Numéro incorrect!',
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (phone) => order.clientNumber = phone.completeNumber,
                        initialCountryCode: 'CI',
                        flagsButtonPadding: const EdgeInsets.only(right: 10),
                        showDropdownIcon: false,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 12,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: clientAvance,
                        decoration: InputDecoration(
                            hintText: "Entrer l'avance donné par le client"
                        ),
                        onChanged: (String value){
                          setState(() {
                            order.avance = double.parse(value);
                          });
                        },
                      ),
                      SizedBox(height: 12,),
                      TextFormField(
                        controller: prixLivraison,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Entrer le prix de la livraison"
                        ),
                        onChanged: (String value){
                          setState(() {
                            order.shippingTotal = double.parse(value);
                          });
                        },
                      ),
                      SizedBox(height: 12,),
                      TextFormField(
                        controller: lieuLivraison,
                        minLines: 2,
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: "Decriver le lieu de livraison"
                        ),
                        onChanged: (String value){
                          setState(() {
                            order.lieu = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  color : Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Liste des produits"),
                      ...List.generate(panier.length, (index) => PanierProductCard(item: panier[index],delete: (){
                        setState(() {
                          panier.remove(panier[index]);
                        });
                      },)),
                      TextFieldFiltre(placeholder: "Entrer le nom de l'article à ajouter", changed: (Product product){
                        var item = PanierProduct();
                        item.name = product.name;
                        item.image = product.images != null && product.images!.isNotEmpty ? product.images![0].url : null;
                        item.quantite = 1;
                        item.price = product.price;
                        item.productId = product.id;
                        setState(() {
                          if(panier.where((element) => element.name == item.name).isNotEmpty){
                            var index = panier.indexWhere((element) => element.name == item.name);
                            var count =  panier[index].quantite!;
                            count += 1;
                            panier[index].quantite = count;
                          }else {
                            panier.add(item);
                          }

                        });
                      },),
                      SizedBox(height: 50,)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        bottomNavigationBar: save == true  ? null :Container(
          padding: EdgeInsets.all(12),
          child: RoundedLoadingButton(
            controller: _btnController,
            child: Text("Enregistrer".toUpperCase(),),onPressed: ()async{
            order.panierProducts = panier;
            double totalDiscount = 0;
            panier.forEach((element) {
                totalDiscount += (element.quantite! * element.price!);
            });
            order.avance  = order.avance ?? 0;
            order.shippingTotal = order.shippingTotal ?? 0;
            order.discountTotal = totalDiscount;
            order.total = order.discountTotal! + order.shippingTotal!;
            order.reste = order.total! - order.avance!;
            order.status = livraisonsStatus[0];
            logger.d(order.toJson());
            if(order.id != null){
              await orderRepository.updateOrder(order);
            }else {
              await orderRepository.createOrder(order);
            }

            _btnController.reset();
            setState((){
              save = true;
            });

          },
          ),
        ),
      ),
    );
  }
}
