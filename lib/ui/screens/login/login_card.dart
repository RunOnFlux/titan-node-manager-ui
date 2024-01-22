import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/ui/screens/home/home_screen.dart';
import 'package:testapp/ui/screens/home/info_card.dart';
import 'package:testapp/ui/screens/home/nodeinfo_card.dart';
import 'package:testapp/ui/screens/inactive/inactive_card.dart';
import 'package:go_router/go_router.dart';
import 'package:testapp/utils/config.dart';
import 'package:testapp/utils/config.dart';

import 'package:testapp/api/services/fetchInfo.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatelessWidget with GetItMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<String?> attemptLogIn(String username, String password) async {
    var url = Uri.parse('${AppConfig().apiEndpoint}/login');
    var res = await http.post(url,
        headers: {
          // "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({"username": username, "password": password}));
    var token = res.body;

    if (res.statusCode == 200) {
      GetIt.I<NodeManagerInfo>().isLoggedIn = true;
      await storage.write(key: "jwt", value: token);

      // fetch data again
      var info = await InfoService().fetchInfo();
      var nodeinfo = await InfoService().fetchNodeInfo();
      var inactiveInfo = await InfoService().fetchInactiveInfo();
      GetIt.I<NodeManagerInfo>().info = info!;

      GetIt.I<NodeManagerInfo>().nodeinfo = nodeinfo!;
      GetIt.I<NodeManagerInfo>().inactiveInfo = inactiveInfo!;
      GetIt.I<NodeManagerInfo>().lastRefresh = info.time;

      return res.body;
    }
    return null;
  }

  Future<int> attemptSignUp(String username, String password) async {
    var url = Uri.parse('${AppConfig().apiEndpoint}/signup');
    var res = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }, body: {
      "username": username,
      "password": password
    });
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              // Login button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      var jwt = await attemptLogIn(username, password);
                      if (jwt != null) {
                        storage.write(key: "jwt", value: jwt);
                        context.push('/home');
                      } else {
                        displayDialog(
                            context, "Incorrect Password", "Try again.");
                      }
                    },
                    child: Text("Log In")),
              ),
              // ElevatedButton(
              //     onPressed: () async {
              //       var username = _usernameController.text;
              //       var password = _passwordController.text;

              //       if (username.length < 4)
              //         displayDialog(context, "Invalid Username",
              //             "The username should be at least 4 characters long");
              //       else if (password.length < 4)
              //         displayDialog(context, "Invalid Password",
              //             "The password should be at least 4 characters long");
              //       else {
              //         var res = await attemptSignUp(username, password);
              //         if (res == 201)
              //           displayDialog(context, "Success",
              //               "The user was created. Log in now.");
              //         else if (res == 409)
              //           displayDialog(
              //               context,
              //               "That username is already registered",
              //               "Please try to sign up using another username or log in if you already have an account.");
              //         else {
              //           displayDialog(
              //               context, "Error", "An unknown error occurred.");
              //         }
              //       }
              //     },
              //     child: const Text("Sign Up"))
            ],
          ),
        ));
  }
}
