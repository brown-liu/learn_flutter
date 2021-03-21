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
        
            child: Row(
            
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: <Widget>[
                Text("This is Menu page"),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    icon: Icon(Icons.ac_unit),
                    label: Text("去HOME页面")),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inboundscan');
                    },
                    icon: Icon(Icons.accessible_rounded),
                    label: Text("入库扫描")),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    icon: Icon(Icons.accessible_rounded),
                    label: Text("退出")),
              ]),
        )
      ],
    )));
  }
}
