
import 'package:flutter/material.dart';
import 'package:cs/single/constant.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,this.icon, this.color
  }) : super(key: key);
  final String text;
  final Function press;
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child:  Center(
        child: ButtonTheme(
            shape: RoundedRectangleBorder(borderRadius: radius),
            child: ElevatedButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding),
                  shape: RoundedRectangleBorder(borderRadius: radius),
                  minimumSize: Size(double.infinity, 50),
                  //primary: widget.color!,
                  elevation: 2,
                  backgroundColor: color ?? kPrimaryColor
                //  padding: EdgeInsets.all(0),
              ),
              onPressed:()=> this.press(),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(this.icon != null)
                    Row(
                      children: [
                        Icon(icon,color: Colors.white,),
                        const SizedBox(width: 12,)
                      ],
                    ),
                  Text(
                    text.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18),
                  ),
                ],
              ) ,
            )),
      ),
    );
  }/*
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding),
      width: double.infinity,
      height: 50,
      child:InkWell(
        onTap:()=> press(),
        child: ClipRRect (
          borderRadius: radius,
          child:Container(
            color: color ?? kPrimaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(icon != null)Icon(icon,color: Colors.white,),
                if(icon != null) const SizedBox(width: 5,),
                Text(
                  text.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18),
                )
              ],
            ),
            //color: kPrimaryColor,
          ),
        ) ,
      ),
    );
  }
*/
}
