import 'package:cs/components/button.dart';
import 'package:cs/model/Magasin.dart';
import 'package:cs/model/User.dart';
import 'package:cs/repository/MagasinRepository.dart';
import 'package:cs/repository/UserRepository.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cs/screen/utils/helpers.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MagasinInformation extends StatefulWidget {
   MagasinInformation({Key? key, required this.magasin, required this.delete,required this.users}) : super(key: key);
    Magasin magasin;
    Function delete;
   List<User> users;
  @override
  State<MagasinInformation> createState() => _MagasinInformationState();
}

class _MagasinInformationState extends State<MagasinInformation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool editor = false;
  TextEditingController controller = TextEditingController();
  var repository = Get.put(MagasinRepository());
  var userRepository = Get.put(UserRepository());
  String? phoneNumber;
  bool editContactGerant = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _init();
  }

  _init() async {
    if(widget.magasin.gerantId != null){
      setState(() {
        phoneNumber = widget.magasin.gerant?.phone!.replaceAll("+225", "") ?? "";
        editContactGerant = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant MagasinInformation oldWidget) {
    // TODO: implement didUpdateWidget
    _init();
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(editor == true ){
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: widget.magasin.id == null  ? "Entrer le nom du magasin": "Modifier le nom du magasin"  ,
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                editor = false;
              });
            },icon: Icon(Iconsax.close_circle, color: Colors.red,),),
            suffix: IconButton(onPressed: (){
              setState(() {
                widget.magasin.name = controller.text;
                if(widget.magasin.id == null){
                  repository.createMagasin(widget.magasin);
                }else {
                  repository.updateMagasin(widget.magasin);
                }
                editor = false;
              });
            },icon: Icon(Icons.check, color: Colors.greenAccent,),)
        ),
      );
    }else {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.magasin.name ?? '',),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if( widget.magasin.principale != true)
                IconButton(onPressed: (){
                  Get.dialog(Dialog(
                    child: StatefulBuilder(builder: (_,setState){
                      editContactGerant = this.editContactGerant;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        height: 230,
                        child: Column(
                          children: [
                            Text(
                              editContactGerant  == true ? "Entrer  le numéro de téléphone du gérant" : "Numéro du téléphone du gérant",
                              style: TextStyle(fontSize: 22),textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            Form(
                              key: _formKey,
                              child: IntlPhoneField(
                                enabled: editContactGerant,
                                initialValue: phoneNumber,
                                flagsButtonMargin: EdgeInsets.symmetric(horizontal: 5),
                                autofocus: true,
                                invalidNumberMessage: 'Numéro incorrect!',
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(fontSize: 25),
                                onChanged: (phone) => phoneNumber = phone.completeNumber,
                                initialCountryCode: 'CI',
                                flagsButtonPadding: const EdgeInsets.only(right: 10),
                                showDropdownIcon: false,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const SizedBox(height: 15),
                            if(editContactGerant == true)
                              Container(
                                child:  Row(
                                  children: [
                                    Expanded(child:  DefaultButton(text: "Anuller",press: ()async{
                                      setState(() {
                                        editContactGerant = false;
                                      });
                                      Get.close(1);
                                    },color: danger,)),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: DefaultButton(text: "Valider",press: ()async{
                                        if (isNullOrBlank(phoneNumber) ||
                                            !_formKey.currentState!.validate()) {
                                          showSnackBar('Entrer un numéro de telephone valide');
                                        } else {
                                          var response = await userRepository.affecterUser({"magasin_id" : widget.magasin.id, "phone" : phoneNumber ,
                                            "patron_id" : userAuth?.id});
                                          if(response.statusCode == 200){
                                            this.setState(() {
                                              widget.magasin.gerant = response.body!;
                                              widget.magasin.gerantId =  response.body!.id;
                                              editContactGerant = false;
                                              phoneNumber =  response.body!.phone!.replaceAll("+225", "");
                                              Get.close(1);
                                            });
                                          }else {
                                            Get.close(1);
                                          }

                                        }
                                      },),
                                    ),
                                  ],
                                ),
                              ),
                            if(editContactGerant == false)
                              const SizedBox(height: 15),
                            if(editContactGerant == false)
                              Container(
                                child: DefaultButton(text: "Modifier", press: (){
                                  setState(() {
                                    editContactGerant = true;
                                  });
                                },color: Colors.green,),
                              )


                          ],
                        ),
                      );
                    },),
                  ));
                }, icon: Icon(Iconsax.user, color: Colors.blue,)),
                IconButton(onPressed: (){
                  setState(() {
                    controller.text = widget.magasin.name ?? '';
                    editor = true;
                  });
                }, icon: Icon(Iconsax.edit, color: kPrimaryColor,)),
                IconButton(onPressed: ()async{
                  Get.dialog(Dialog(child: Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Voulez-vous supprimer\n ce magasin", style: TextStyle(fontWeight: FontWeight.w200),textAlign: TextAlign.center,),
                        SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(onPressed: (){
                              Get.close(1);
                            }, child: Text('NON', style: TextStyle(color: Colors.red),)),
                            TextButton(onPressed: ()async{
                              if(widget.magasin.id != null){
                                await  repository.deleteMagasin(widget.magasin.id!);
                                widget.delete(widget.magasin);
                                Get.close(1);
                              }else{
                                widget.delete(widget.magasin);
                                Get.close(1);
                              }

                            }, child: Text('OUI', style: TextStyle(color: kPrimaryColor),)),
                          ],
                        )
                      ],
                    )
                    ,),));

                }, icon: Icon(Iconsax.trash, color: danger,)),
              ],
            )

          ],
        ),
      );
    }
  }
}
