
import 'package:cs/model/Product.dart';
import 'package:cs/repository/ProductRepository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/theme.dart';

class TextFieldFiltre extends StatefulWidget {
  TextFieldFiltre({
    Key? key,
    required this.placeholder,
    required this.changed,this.none, this.enabled, this.value
  });
  final String placeholder;
  final Function changed;
  bool?  none;
  bool? enabled;
  String? value;
  @override
  TextFieldFiltreState createState() => TextFieldFiltreState();
}

class TextFieldFiltreState extends State<TextFieldFiltre> {
  TextEditingController controller = TextEditingController();
  List<Product> showItems = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<Product> itemsFiltre = [];
  var repository = Get.put(ProductRepository());
  @override
  void initState() {
    super.initState();
    if(widget.value != null){
      setState(() {
        controller.text = widget.value!;
      });
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
      } else {
        if(_overlayEntry != null){
          _overlayEntry!.remove();
          _overlayEntry!.dispose();
        }
      }
    });

  }


  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);
  }
  ListTile listElement(Product value){
    return ListTile(title: Text("${value.name!}"), onTap: () {
      setState(() {
        showItems.clear();
        controller.text = "";
      });
      _overlayEntry!.remove();
      changed(value);
    });
  }
  OverlayEntry _createOverlayEntry() {
    RenderObject? renderBox = context.findRenderObject();
    var size = renderBox!.semanticBounds.size;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height),
            child: Material(
              elevation: 2,
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: <Widget>[
                  ...List.generate(showItems.length, (index){
                    return listElement(showItems[index]);
                  })
                ],
              ),
            ),
          ),
        )
    );
  }
  Future filtre(String value)async{
    if(value.isEmpty){
      setState(() {
        showItems = [];
        _overlayEntry!.remove();
      });
    }else {
      var response =await repository.search(value);
      if(response.statusCode == 200){
        setState(() {
          showItems = response.body!;
          _overlayEntry = _createOverlayEntry();
          Overlay.of(context)?.insert(_overlayEntry!);
        });
      }
    }

  }
  void changed(dynamic value){
    widget.changed(value);
  }


  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        enabled: widget.enabled,
        focusNode: _focusNode,
        controller: controller,
        //onSaved: (newValue){filtre(newValue!);},
        onChanged: (value)async{
          await filtre(value);
        },
        decoration:widget.none == true ? noneInputDecorationCell(widget.placeholder): InputDecoration(hintText: widget.placeholder),
      ),
    );
  }
}