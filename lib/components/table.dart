

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableData extends StatefulWidget {
  TableData({Key? key, required this.columns, required this.rows, required this.loading, this.empty}) : super(key: key);
  List<DataColumn> columns;
  List<DataRow> rows;
  bool loading;
  String? empty;
  @override
  State<TableData> createState() => _TableState();
}

class _TableState extends State<TableData> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int paginationCount = 10;
  int page = 1;
  int index = 0;
  int totalPage = 0;
  List<DataRow>  rowsShowAll = [];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    setState(() {
      rowsShowAll = paginateAction(index);
    });
  }

  List<DataRow>   paginateAction(int index){
    totalPage = (widget.rows.length/ paginationCount).ceil();
    var itemsValues = widget.rows;
    int start = index * paginationCount;
    int end =  (index + 1) * paginationCount > (itemsValues.length)
        ? itemsValues.length : (index + 1) * paginationCount;
    List<DataRow>  paginates = itemsValues.getRange(start,end).toList();
    return paginates;
  }

  void backPagination(){
    setState(() {
      if(page >  1) {
        page -= 1;
        index -= 1;
        rowsShowAll = paginateAction(index);
      }
    });

  }
  void nextPagination(){
    setState(() {
      if(page < totalPage ){
        page += 1;
        index += 1;
        rowsShowAll= paginateAction(index);
      }
    });

  }

  Widget get selectPagination{
    return DropdownButton<int>(
        value: paginationCount,
        icon: Icon(Icons.arrow_drop_down),
        onChanged: (int? newValue){
          setState(() {
            paginationCount = newValue!;
            page = 1;
            index = 0;
            totalPage = (widget.rows.length/ paginationCount).ceil();
            rowsShowAll = paginateAction(0);
          });

        },
        items: [10, 25,50,100].map((e) =>  DropdownMenuItem(child: Text(e.toString()),value: e)).toList()
    );
  }

  @override
  void didUpdateWidget(covariant TableData oldWidget) {
    // TODO: implement didUpdateWidget
    setState(() {
      rowsShowAll = paginateAction(index);
    });
    super.didUpdateWidget(oldWidget);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.loading == true){
        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
    }else {
      return Column(
        mainAxisAlignment: widget.rows.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if(rowsShowAll.isEmpty && widget.empty == null)
            Image.asset("assets/images/empty.jpg", width: 300,),
          if(rowsShowAll.isEmpty  && widget.empty == null)
            Text("Aucun item n'a été ajouter", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),textAlign: TextAlign.center,),
          if(rowsShowAll.isEmpty  && widget.empty != null)
            Text(widget.empty!, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),textAlign: TextAlign.center,),
          if(rowsShowAll.isNotEmpty )
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  ...widget.columns
                ],
                rows: [
                  ...widget.rows
                ],
              ),
            ),
          SizedBox(height: 12,),
          if(widget.rows.isNotEmpty && widget.rows.length.isGreaterThan(10))
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  selectPagination,
                  IconButton(onPressed: ()=>backPagination(), icon: Icon(Icons.arrow_back_ios,  color: page >  1 ? Colors.black : Colors.black12),iconSize: 12,),
                  Text("Page $page/$totalPage"),
                  IconButton(onPressed: ()=>nextPagination(), icon: Icon(Icons.arrow_forward_ios, color : page < totalPage ? Colors.black : Colors.black12 ), iconSize: 12,)
                ])
        ],
      );
    }

  }
}
