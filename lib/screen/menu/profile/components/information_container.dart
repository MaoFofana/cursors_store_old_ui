import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class InformationContainer extends StatefulWidget {
  InformationContainer({Key? key, required this.label, required this.information, required this.update, this.active, this.hint, this.icon, this.array,
    this.type, this.edit}) : super(key: key);
  String label;
  String? information;
  String? edit;
  Function update;
  bool? active;
  String? hint;
  IconData? icon;
  List<String>? array;
  TextInputType? type;
  @override
  State<InformationContainer> createState() => _InformationContainerState();
}

class _InformationContainerState extends State<InformationContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool update = false;
  TextEditingController controller =  TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    controller.text = widget.edit ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InformationContainer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      update = false;
    });
  }

  Row get show {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if(widget.icon != null)
              Icon(widget.icon),
            SizedBox(width: 12,),
            Text(widget.label),
          ],
        ),
        Row(
          children: [
            Text(widget.information ?? ""),
            SizedBox(width: 5,),
            if(widget.active != false)
            IconButton(onPressed: (){
              setState(() {
                update = true;
              });
            }, icon: Icon(Iconsax.edit_2, color: kPrimaryColor,))
          ],
        )
      ],
    );
  }


  Widget get edit {
    if(widget.array == null){
      return TextFormField(
        controller: controller,
        keyboardType: widget.type ?? TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: widget.hint,
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                update = false;
              });
            },icon: Icon(Iconsax.close_circle, color: Colors.red,),),
            suffix: IconButton(onPressed: (){
              widget.update(controller.text);
              setState(() {
                update = false;
              });
            },icon: Icon(Icons.check, color: Colors.greenAccent,),)
        ),
      );
    }
    else {
      return DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: widget.hint,
          //labelText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          //suffixIcon: Icon(IconlyLight.location)
        ),
        // Initial Value
        value: widget.information,
        // Down Arrow Icon

        // Array list of items
        items: widget.array!.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            widget.update(newValue);
            update = false;
          });
        },
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
    /*  decoration:  BoxDecoration(
        border: Border(top: BorderSide(width: 0.3))
      ),*/
      child: update == true ? edit : show,
    );
  }
}
