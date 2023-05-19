import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/model/Order.dart';
import 'package:cs/model/PanierProduct.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/repository/OrderRepository.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ModalOrder extends StatefulWidget {
  ModalOrder({Key? key,required this.product}) : super(key: key);
  Product? product;
  @override
  State<ModalOrder> createState() => _ModalOrderState();
}

class _ModalOrderState extends State<ModalOrder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int quantite = 0;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  TextEditingController clientName = TextEditingController();
  TextEditingController clientNumber = TextEditingController();
  TextEditingController clientAvance = TextEditingController();
  TextEditingController lieuLivraison = TextEditingController();
  TextEditingController prixLivraison = TextEditingController();

  bool save = false;
  Order order = Order();
  var orderRepository = Get.put(OrderRepository());

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
        height: 550,
        width: GetPlatform.isMobile ? null  : 400,
        padding: EdgeInsets.all(12),
        child: save == true
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
                    setState(() {
                      save = false;
                    });
                    Get.back();
                  },color: danger,)),
                ],
              )
            ],
          ),
        ):SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12,),
              Text("Entrer les informations de la commande",textAlign: TextAlign.center,),
              SizedBox(height: 12,),
              TextFormField(
                controller: clientName,
                decoration: InputDecoration(
                    hintText: "Entrer le nom du client"
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
              SizedBox(height: 12,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Entrer la quantité"
                ),
                onChanged: (String value){
                  setState(() {
                    quantite = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(
                    child: DefaultButton(
                      color: danger,
                      text:  "ANULLER", press: (){
                      setState(() {
                        quantite = 0;
                      });
                      Get.back();
                    },),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: RoundedLoadingButton(child: Text("VALIDER", style: TextStyle(fontSize: 18),),onPressed: () async{
                      List<PanierProduct> panier = [];
                      var item = PanierProduct();
                      item.name = widget.product!.name;
                      item.image = widget.product!.images != null && widget.product!.images!.isNotEmpty ? widget.product!.images![0].url : null;
                      item.quantite = quantite;
                      item.price = widget.product!.price;
                      item.productId = widget.product!.id;
                      panier.add(item);
                      var orderRepository = Get.put(OrderRepository());
                      order.panierProducts = panier;
                      logger.d(order.panierProducts!.length);
                      order.avance  = order.avance ?? 0;
                      order.shippingTotal = order.shippingTotal ?? 0;
                      order.discountTotal = quantite * item.price!;
                      order.total = order.discountTotal! + order.shippingTotal!;
                      order.reste = order.total! - order.avance!;
                      order.status = livraisonsStatus[0];

                      await orderRepository.createOrder(order);
                      clientName.text ="";
                      clientNumber.text ="";
                      clientAvance.text ="";
                      lieuLivraison.text ="";
                      prixLivraison.text ="";
                      _btnController.reset();
                      setState(() {
                        save = true;
                        order = Order();
                      });

                    }, controller: _btnController,),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
