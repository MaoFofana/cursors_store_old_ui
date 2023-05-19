import 'package:cs/components/button.dart';
import 'package:cs/components/rounded_button.dart';
import 'package:cs/model/Product.dart';
import 'package:cs/screen/stock/rapport/rapport_screen.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RapportSelectModal extends StatefulWidget {
  RapportSelectModal({Key? key, this.product}) : super(key: key);
  Product? product;
  @override
  State<RapportSelectModal> createState() => _RapportSelectModalState();
}

class _RapportSelectModalState extends State<RapportSelectModal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  DateTime? start;
  DateTime? end;
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
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
    return  Dialog(child: Container(
      height: 230,
      width: GetPlatform.isMobile ? null  : 400,
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text("Selectionner la période"),
          SizedBox(height: 12,),
          TextFormField(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101));
              if (picked != null) {
                setState(() {
                  startController.text = "${picked.day}/${picked.month}/${picked.year}";
                  start = DateTime(picked.year, picked.month,picked.day, 00,00,00);
                });
              }
            },
            controller: startController,
            decoration: InputDecoration(
                hintText: "Début"
            ),
          ),
          SizedBox(height: 12,),
          TextFormField(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101));
              if (picked != null) {
                setState(() {
                  endController.text = "${picked.day}/${picked.month}/${picked.year}";
                  end = DateTime(picked.year, picked.month,picked.day, 00,00,00);
                });
              }
            },
            controller: endController,
            decoration: InputDecoration(
                hintText: "Fin"
            ),
          ),
          SizedBox(height: 12,),
          Row(
            children: [
              Expanded(child: DefaultButton(text: "Anuller", press: (){
                setState(() {
                  endController.text = "";
                  startController.text = "";
                  end = null;
                  start = null;
                });
                Get.back();
              },color: danger,)),
              SizedBox(width: 12,),
              Expanded(child: RoundedLoadingButton(child: Text("Valider".toUpperCase(), style: TextStyle(fontSize: 18),),onPressed: (){
                setState(() {
                  endController.text = "";
                  startController.text = "";
                });
                Get.back();
                Get.to(RapportScreen(start: start!, end: end!, product:widget.product,));
              },controller: _btnController,))
            ],
          )
        ],
      ),
    ),);
  }
}
