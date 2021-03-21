import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:convert';

class InboundScan extends StatefulWidget {
  @override
  _InboundScan createState() => _InboundScan();
}

class _InboundScan extends State<InboundScan> {
  @override
  void initState() {
    super.initState();

    getData();
  }

  double height = 0.0;
  double width = 0;
  double length = 0;

  void getData() async {
    try{
      Response response = await get("https://10.0.2.2:5001/test");
    Map data = jsonDecode(response.body);
    setState(() {
      height = data['Width'];
      width = data['Height'];
      length = data['Length'];
    });
    }
    catch(e){
      print('error => $e');
    }
    

    print(height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Text('长为：$height'),
      Text('宽为：$width'),
      Text('高为$length'),
      TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
          icon: Icon(Icons.access_alarm_outlined),
          label: Text('GO to Menu'))
    ])));
  }
}
