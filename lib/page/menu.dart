import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final storage = new FlutterSecureStorage();

  void ClearMemory() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
          Container(
              child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  icon: Icon(Icons.ac_unit),
                  label: Text("去HOME页面"))),
          Container(
              child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/inboundscan');
                  },
                  icon: Icon(Icons.accessible_rounded),
                  label: Text("入库扫描"))),
          Container(
            child: ElevatedButton.icon(
                onPressed: () {
                  ClearMemory();
                  Navigator.pushNamed(context, '/login');
                },
                icon: Icon(Icons.accessible_rounded),
                label: Text("退出")),
          )
        ])));
  }
}
