import 'package:flutter/material.dart';
import 'page/home.dart';
import 'page/login.dart';
import 'page/menu.dart';

void main() {
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
            '/menu': (context) => Menu()
          },
        )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
