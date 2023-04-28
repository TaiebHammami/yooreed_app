import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class ScanController extends GetxController{
  TextEditingController qrContentEdit = TextEditingController();
  var qrCode = ''.obs ;
  String scannerQrcode = '';





  Future<void> scanQr()async{
    try
        {


             scannerQrcode = await FlutterBarcodeScanner.
          scanBarcode('#ff6666', 'cancel', false, ScanMode.QR) ;
          Get.snackbar('Result', 'QR Code' + scannerQrcode,
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds: 5));
          qrContentEdit.text = scannerQrcode;

        }
        on PlatformException {}
  }
 }