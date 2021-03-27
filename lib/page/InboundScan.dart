import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InboundScan extends StatefulWidget {
  @override
  _InboundScan createState() => _InboundScan();
}

class _InboundScan extends State<InboundScan> {
  @override
  void initState() {
    super.initState();
    GetToken();
  }

  void GetToken() async {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: 'accessToken');
  }

  String token = '';
  double height = 0.0;
  double width = 0;
  double length = 0;
  String trackingNumber = '';
  String memberShipId = '';
  String reference = '';
  String inboundScanDate;

  void getData() async {
    try {
      final response = await get(
          "http://auslink.group/api/mobile/get_awaiting_inbound_parcel_info?trackingNumber=$trackingNumber",
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      Map data = jsonDecode(response.body);
      print(data);
      setState(() {
        height = data['parcel']['Width'];
        width = data['parcel']['Height'];
        length = data['parcel']['Length'];
        memberShipId = data['parcel']['MembershipId'].toString();
        reference = data['parcel']["Reference"];
        inboundScanDate = data['parcel']["InboundScanDate"];
      });
    } catch (e) {
      print('error => $e');
    }

    print(height);
  }

  void updateInformation() async {
    print(height);
    print(width);
    print(length);
    print(memberShipId);
    print(reference);
    print(inboundScanDate);
  }

  Future scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        trackingNumber = barcode.rawContent;
      });
      getData();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          trackingNumber = "Camera access denied";
        });
      } else {
        setState(() {
          trackingNumber = "Unknown error";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
              onPressed: scan,
              icon: Icon(Icons.camera),
              label: Text("点击此处扫描"))),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          child: Text(
            "快递号： $trackingNumber",
            style: TextStyle(fontSize: 25),
          )),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          child: Text("会员号:  $memberShipId", style: TextStyle(fontSize: 25))),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          child: Text("注释:  $reference", style: TextStyle(fontSize: 25))),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          child: Text("高:  $height", style: TextStyle(fontSize: 25))),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          child: Text("宽:  $width", style: TextStyle(fontSize: 25))),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(10),
          child: Text("长:  $length", style: TextStyle(fontSize: 25))),
      Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
              onPressed: updateInformation,
              icon: Icon(Icons.handyman),
              label: Text("提交"))),
      Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
              icon: Icon(Icons.flip_to_back),
              label: Text("返回")))
    ])));
  }
}
