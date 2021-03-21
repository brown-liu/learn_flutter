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
  String wrongCredential = "";

  @override
  Widget build(BuildContext context) {
    makePostRequest(body) async {
      final uri = 'http://10.0.2.2:5000/admin-login';
      final headers = {'Content-Type': 'application/json'};
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      var responseBody = json.decode(response.body);

      if (responseBody["state"] == 1) {
        print("OK");
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'accessToken', value: responseBody['token']);
        await storage.write(
            key: 'companyName',
            value: responseBody['warehouse']['CompanyName']);
        await storage.write(
            key: 'countryName',
            value: responseBody['warehouse']['CountryName']);
        await storage.write(key: 'userName', value: responseBody['name']);

        Navigator.pushNamed(context, '/home');
      } else {
        setState(() {
          wrongCredential = "用户名或者密码错误！";
        });
      }
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
                  child: Text('$wrongCredential'),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '用户名',
                      errorText: invalidName ? "用户名不得为空" : null,
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
                      errorText: invalidPassword ? "密码不得为空" : null,
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
