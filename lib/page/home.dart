import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String company = "...";
  String country = "...";
  String userName = "...";
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserWarehouse();
  }

  void getUserWarehouse() async {
    String _company = await storage.read(key: 'companyName');
    String _country = await storage.read(key: 'countryName');
    String _userName = await storage.read(key: 'userName');
    setState(() {
      company = _company;
      country = _country;
      userName = _userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              "Welcome $userName",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue),
            )),
        Container(
            padding: EdgeInsets.all(20),
            child: Text("$company - $country",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue))),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
          child: Text("去操作菜单"),
        )
      ],
    )));
  }
}
