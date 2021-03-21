import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learn_flutter/page/InboundScan.dart';
import 'page/home.dart';
import 'page/login.dart';
import 'page/menu.dart';
import 'page/InboundScan.dart';
import 'dart:io';
import 'dart:convert';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Kiwi Parcel PDA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: Colors.red[300],
        ),
        body: MaterialApp(
          initialRoute: '/login',
          routes: {
            '/home': (context) => Home(),
            '/login': (context) => Login(),
            '/menu': (context) => Menu(),
            '/inboundscan': (context) => InboundScan()
          },
        )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
