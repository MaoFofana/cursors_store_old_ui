import 'package:cs/repository/AuthentificationRepository.dart';
import 'package:cs/screen/home/home_screen.dart';
import 'package:cs/single/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var repository = Get.put(AuthenficationRepository());
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
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Qr code scanner", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),),
            ),
            body: Container(
                alignment: Alignment.center,
              child : Container(
                height: 400,
                width: 300,
                child: MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args)async {
                      if (barcode.rawValue == null) {
                        logger.d('Failed to scan Barcode');
                      } else {
                        final String code = barcode.rawValue!;
                        await repository.authenticationQr(userAuth!.phone!, code);
                        Get.to(HomeScreen());
                        logger.d('Barcode found! $code');

                      }
                    }),
              )
            )
        ));
  }
}
