import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Text("HOME PAGE"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
          child: Text("Go to Menu"),
        )
      ],
    )));
  }
}
