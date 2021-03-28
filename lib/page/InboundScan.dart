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

  TextEditingController lengthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController memberIdController = TextEditingController();
  void GetToken() async {
    final storage = new FlutterSecureStorage();
    token = await storage.read(key: 'accessToken');
  }

  String token = '';
  double height = 0.0;
  double width = 0;
  double length = 0;
  double weight = 0;
  String trackingNumber = '';
  int memberShipId = 0;
  String reference = '';
  String inboundScanDate;

  void getData() async {
    if (trackingNumber.isEmpty) {
      return;
    }
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
        weight = data['parcel']['Weight'];
        memberShipId = data['parcel']['MembershipId'];
        reference = data['parcel']["Reference"];
        inboundScanDate = data['parcel']["InboundScanDate"];
      });
    } catch (e) {
      print('error => $e');
    }

    print(height);
  }

  void clearScreen() {
    setState(() {
      height = 0;
      width = 0;
      length = 0;
      weight = 0;
      memberShipId = 0;
      reference = '';
      inboundScanDate = '';
      trackingNumber = '';
    });
  }

  void alertUser() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("网络错误"),
            content: new Text("无法提取数据库信息"),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("关闭"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void succeedUpdateAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("搞定"),
            content: new Text("更新成功"),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("关闭"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void updateInformation() async {
    if (trackingNumber == "") {
      alertUser();
      return;
    }

    Map<String, dynamic> data = {
      'height': heightController.text,
      'width': widthController.text,
      'length': lengthController.text,
      'weight': weightController.text,
      'membershipId': memberIdController.text,
      'trackingNumber': trackingNumber
    };
    final url = "http://auslink.group/api/mobile/update_inbound_parcel_info";
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };
    final jsonData = jsonEncode(data);
    final encoding = Encoding.getByName('utf-8');

    Response response =
        await post(url, headers: headers, encoding: encoding, body: jsonData);
    dynamic result;
    if (response.body.isNotEmpty) {
      result = json.decode(response.body);

      switch (result["state"]) {
        case 0:
          succeedUpdateAlert();
          print(result);
          clearScreen();
          break;
        case 1:
          succeedUpdateAlert();
          print(result);
          break;
        case 2:
          print(result);
          break;
        case 3:
          print(result);
          break;
        case 4:
          succeedUpdateAlert();
          print(result);
          break;
      }
      print(result);
    }
  }

  Future scan() async {
    clearScreen();
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
    return Center(
        child: SingleChildScrollView(
      padding: EdgeInsets.all(10),
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
            margin: EdgeInsets.all(5),
            child: Text(
              "快递号： $trackingNumber",
              style: TextStyle(fontSize: 20),
            )),
        TextFormField(
          controller: memberIdController..text = "$memberShipId",
          decoration: const InputDecoration(labelText: "会员号"),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(5),
            child: Text("注释:  $reference", style: TextStyle(fontSize: 20))),
        TextFormField(
          controller: lengthController..text = "$length",
          scrollPadding: EdgeInsets.all(10),
          decoration: const InputDecoration(labelText: "长"),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          validator: (String value) {
            if (value == null || value.isEmpty) {
              return "必填项目";
            }
            return null;
          },
        ),
        TextFormField(
          controller: widthController..text = "$width",
          decoration: const InputDecoration(labelText: "宽"),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          validator: (String value) {
            if (value == null || value.isEmpty) {
              return "必填项目";
            }
            return null;
          },
        ),
        TextFormField(
          controller: heightController..text = "$length",
          decoration: const InputDecoration(labelText: "高"),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          validator: (String value) {
            if (value == null || value.isEmpty) {
              return "必填项目";
            }
            return null;
          },
        ),
        TextFormField(
            controller: weightController..text = "$weight",
            scrollPadding: EdgeInsets.all(10),
            decoration: const InputDecoration(labelText: "重量"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (String value) {
              if (value == null || value.isEmpty) {
                return "必填项目";
              }
              return null;
            }),
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
      ]),
    ));
  }
}
