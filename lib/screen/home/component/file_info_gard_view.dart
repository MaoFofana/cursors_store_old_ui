import 'package:cs/model/Dashboard.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'file_info_card.dart';

class FileInfoCardGridView extends StatefulWidget {
  FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.dashboard
  }) : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  Dashboard dashboard;
  @override
  FileInfoCardGridViewState createState() => FileInfoCardGridViewState();
}

class FileInfoCardGridViewState extends State<FileInfoCardGridView> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount:2,
      crossAxisSpacing: defaultPadding ,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: widget.childAspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        FileInfoCard(
            //widget: const BienDurableScreen(),
            info: CloudStorageInfo(
              title: "Prodts ajoutés",
              count:widget.dashboard.ajouter,
              color: Color(0xFF23A236),
              colorHover: Color(0x1356E051),
              percentage: (widget.dashboard.ajouter * 100) / widget.dashboard.inStock,
            )
        ),
        FileInfoCard(
          //widget: const BienDurableScreen(),
            info: CloudStorageInfo(
              title: "Prodts vendus",
              count:widget.dashboard.sortie,
              color: Color(0xFFD59716),
              colorHover: Color(0x1356E051),
              percentage: (widget.dashboard.sortie * 100) / widget.dashboard.inStock,
            )
        ),
        FileInfoCard(
          //widget: const BienDurableScreen(),
            info: CloudStorageInfo(
              title: "Prodts en stock",
              count:widget.dashboard.inStock,
              color: Color(0xFF1126DA),
              colorHover: Color(0x1356E051),
              percentage: 100,
            )
        ),

        FileInfoCard(
          //widget: const BienDurableScreen(),
            info: CloudStorageInfo(
              title: "Commandes",
              count:widget.dashboard.commande,
              color: Color(0xFFA811DA),
              colorHover: Color(0x1356E051),
              percentage: widget.dashboard.commande == 0 ? 100 : widget.dashboard.commande.toDouble(),
            )
        ),
      ],
    );

  }
}



class CloudStorageInfo {
  final String? title;
  final int?  count;
  final double? percentage;
  final Color? color;
  final Color? colorHover;


  CloudStorageInfo({
    this.count,
    this.title,
    this.percentage,
    this.color,
    this.colorHover,
  });
}


