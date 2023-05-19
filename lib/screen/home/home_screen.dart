import 'package:cs/components/bottom_menu.dart';
import 'package:cs/components/table.dart';
import 'package:cs/model/Dashboard.dart';
import 'package:cs/model/NotifVersion.dart';
import 'package:cs/model/Order.dart';
import 'package:cs/repository/DashboardRepository.dart';
import 'package:cs/repository/NotifcationVersionRepository.dart';
import 'package:cs/repository/OrderRepository.dart';
import 'package:cs/screen/auth/qr_scanner.dart';
import 'package:cs/single/constant.dart';
import 'package:cs/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'component/file_info_gard_view.dart';
import 'orders/order_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  List<Color> get availableColors => const <Color>[
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;
  List<Order> orders = [];

  Dashboard dashboard = Dashboard(0,0,0,0,100);
  String _dropdownValue =  "Aujourd'hui";
  final List<String> _dropdownValues = [
    "Aujourd'hui",
    "Semaine",
    "Mois",
  ];

  var repository = Get.put(OrderRepository());
  var dashboardRepository = Get.put(DashboardRepository());
  var notifVersionRepository = Get.put(NotificationVersionRepository());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initVersion();
    _getData(periode: _dropdownValues.first);
  }

  _initVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    var response = await notifVersionRepository.getLastVersion();
    if(response.statusCode == 200){
        NotifVersion notifVersion = response.body!;
        if(notifVersion.version != version && storage.read('version') != notifVersion.version){
          Get.dialog(
              Dialog(child: Container(
                 decoration: BoxDecoration(
                   borderRadius: radius,
                   color: Colors.white
                 ),
                 padding: EdgeInsets.all(12),
                  height: 400,
                width:  400 ,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide())
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20,),
                            Text("Nouvelle version".toUpperCase(), style: TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                            IconButton(onPressed: (){
                              storage.write("version", notifVersion.version);
                              Get.back();
                            }, icon: Icon(Iconsax.close_circle, color: danger,)),
                          ],
                        ),
                      ),
                      SizedBox(height: 8,),
                      HtmlWidget(notifVersion.feature!,
                        onLoadingBuilder: (context, element, loadingProgress) => CircularProgressIndicator(),
                        onTapUrl: (url) async {
                          storage.write("version", notifVersion.version);
                          if (!await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $url';
                          }
                          Get.back();
                          return Future.value(true);
                        },
                        // set the default styling for text
                        textStyle: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                ),
              ),barrierDismissible: false
          );
        }
    }
  }

  _getData({String? periode})async{
    DateTime start = DateTime.now();
    DateTime end  = DateTime.now();
    var dateNow = DateTime.now();

    if(periode == _dropdownValues.last){
      end = DateTime(dateNow.year,dateNow.month,dateNow.day);
      start = DateTime(dateNow.year,dateNow.month,0);
    }else if(periode == _dropdownValues[1]){
      start = dateNow.subtract(Duration(days: 7));
    }
    start = start.subtract(Duration(days: 1));
    end = end.add(Duration(days: 1));
    var response = await dashboardRepository.getByPeriode(start.millisecondsSinceEpoch.toString(), end.millisecondsSinceEpoch.toString());
    if(response.statusCode == 200){
      dashboard = response.body!;
      setState(() {
        _dropdownValue = periode!;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Acceuil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
          actions: [
            IconButton(onPressed: (){
                Get.to(OrderScreen());
            }, icon: Icon(Iconsax.shopping_cart)),
           /* IconButton(onPressed: (){
                Get.to(QrCodeScannerScreen());
            }, icon: Icon(Iconsax.monitor,color: Colors.black,)),
            IconButton(onPressed: (){

            }, icon: Icon(Iconsax.notification,color: Colors.black,)),*/
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gérer vos \nproduits et ventes avec  facilité', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
               /* if(orders.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: radius
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("Commandes recentes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      SizedBox(height: 12,),
                        TableData(
                        empty:  "Aucune commande recente",
                          loading: false,
                          columns: [
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Nom du client")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Actions")),
                          ], rows: [
                        ...List.generate(orders.length, (index) => DataRow(cells: [
                          DataCell(Text(dateConvert(orders[index].createdAt!))),
                          DataCell(Text(orders[index].clientName ?? "")),
                          DataCell(Text(orders[index].status ?? "")),
                          DataCell(Row(children: [
                            IconButton(onPressed: (){
                              Get.to(ShowOrderScreen(),arguments: orders[index]);
                            }, icon: Icon(Iconsax.eye, color: Colors.green,)),
                            if(orders[index].status == livraisonsStatus.first)
                              IconButton(onPressed: (){
                                Get.to(CreateOrderScreen(order:orders[index]));
                              }, icon: Icon(Iconsax.edit_2, color: Colors.blue,)),
                            if(orders[index].status == livraisonsStatus.first)
                              IconButton(onPressed: (){
                                Get.defaultDialog(
                                  radius: roundedValue,
                                  middleText: "",
                                  title: "Vous-voulez vous \anuller ${orders[index].number!}",
                                  cancel: TextButton(onPressed: (){
                                    Get.close(1);
                                  }, child: Text("Non", style: TextStyle(color: danger),)),
                                  confirm: TextButton(onPressed: () async{
                                    setState(() {
                                      orders[index].status = livraisonsStatus.last;
                                      repository.updateOrder(orders[index]);
                                    });
                                    Get.close(1);
                                  }, child: Text('Oui')),
                                  cancelTextColor: danger,
                                  confirmTextColor:  Colors.white,

                                );
                              }, icon: Icon(Iconsax.trash, color: danger,))
                          ],))
                        ]))
                      ])
                    ],
                  ),
                ),
                SizedBox(height: 12,),*/
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: radius
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                          width : double.infinity,
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child:  DropdownButton(
                            items: _dropdownValues
                                .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            )).toList(),
                            onChanged: (String? value) {
                              _getData(periode:  value);

                            },
                            isExpanded: false,
                            value: _dropdownValue,
                          ) ,
                      ),

                      FileInfoCardGridView(dashboard: dashboard,)
                    ],
                  ) ,
                )

              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomMenu(index: 0),
      ),
    );

  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? kSecondaryColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: kSecondaryColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(4, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Produits ajoutés';
                break;
              case 1:
                weekDay = 'Stock';
                break;
              case 2:
                weekDay = 'Commandes';
                break;
              case 3:
                weekDay = 'Clients';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: kSecondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('PA', style: style);
        break;
      case 1:
        text = const Text('PR', style: style);
        break;
      case 2:
        text = const Text('PV', style: style);
        break;
      default:
        text = const Text('Clt', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

}
