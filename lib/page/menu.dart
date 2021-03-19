import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Text("This is Menu page"),
      TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          icon: Icon(Icons.ac_unit),
          label: Text("去HOME页面")),
      TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          icon: Icon(Icons.accessible_rounded),
          label: Text("退出"))
    ])));
  }
}
