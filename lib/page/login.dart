import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool invalidName = false;
  bool invalidPassword = false;

  @override
  Widget build(BuildContext context) {
    int statusCode = 0;
    String responseBody = null;

    makePostRequest(body) async {
      final uri = 'http://auslink.group/api/Account/login';
      final headers = {'Content-Type': 'application/json'};
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      statusCode = response.statusCode;
      responseBody = response.body;
      print(responseBody);
    }

    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "操作登录",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '用户名',
                      errorText: invalidName ? "用户名不正确" : null,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "密码",
                      errorText: invalidPassword ? "密码不正确" : null,
                    ),
                  ),
                ),
                Container(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (passwordController.text == '') {
                        setState(() {
                          invalidPassword = true;
                        });
                      }
                      if (nameController.text == '') {
                        setState(() {
                          invalidName = true;
                        });
                      } else {
                        Map<String, dynamic> data = {
                          "email": nameController.text,
                          "password": passwordController.text,
                        };
                        makePostRequest(data);
                        // Navigator.pushNamed(context, '/home');
                      }
                    },
                    icon: Icon(Icons.dashboard),
                    label: Text("Login"),
                  ),
                ),
              ],
            )));
  }
}
