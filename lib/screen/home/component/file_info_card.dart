import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'file_info_gard_view.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
    this.widget,
  }) : super(key: key);

  final CloudStorageInfo info;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        //color: Colors.grey,
        borderRadius: radius,
      ),
      child:InkWell(
        hoverColor: info.colorHover ,
        borderRadius: radius,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex : 1,
                  child:   Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.75),
                    height: 40,
                    width: 10000,
                    decoration: BoxDecoration(
                      color: info.color!.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(info.count.toString(),textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                )

              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title!,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                ProgressLine(
                  color: info.color,
                  percentage: info.percentage,
                ),
              ],
            )
          ],
        ),
        /*onTap: (){
          Get.to(widget);
        },*/
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = kPrimaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: ( constraints.maxWidth * (percentage ?? 0 / 100)).isNaN ? 0: ((constraints.maxWidth.isNaN ? 0 : constraints.maxWidth ) * (percentage ?? 0 / 100)),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
