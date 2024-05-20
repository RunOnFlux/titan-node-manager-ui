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
import 'package:testapp/ui/components/info_card.dart';
import 'package:testapp/ui/components/signup.dart';

import 'package:testapp/ui/screens/home/nodeinfo_card.dart';
import 'package:testapp/ui/screens/inactive/old_inactive_card.dart';
import 'package:go_router/go_router.dart';
import 'package:testapp/utils/config.dart';
import 'package:testapp/ui/app/loading.dart';

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
    print('attempting login');
    var url = Uri.parse('${AppConfig().apiEndpoint}/login');

    // strip whitespace from front and back of username and password
    username = username.trim();
    password = password.trim();

    var res = await http.post(url,
        headers: {
          // "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({"username": username, "password": password}));
    var token = res.body;

    if (res.statusCode == 200) {
      GetIt.I<NodeManagerInfo>().isLoggedIn = true;
      GetIt.I<NodeManagerInfo>().user = username;

      await storage.write(key: "jwt", value: token);
      await storage.write(key: "user", value: username);

      // use fetchinfo
      await InfoService().fetchInfo();

      return res.body;
    }
    print('Failed to log in');
    return null;
  }

  Future<int> attemptSignUp(
      String username, String password, String address) async {
    var url = Uri.parse('${AppConfig().apiEndpoint}/signup');
    var res = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }, body: {
      "username": username,
      "password": password,
      "address": address
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
                        // save token
                        GetIt.I<NodeManagerInfo>().setToken(jwt);
                        GetIt.I<NodeManagerInfo>().isLoggedIn = true;
                        GetIt.I<NodeManagerInfo>().user = username;
                        await storage.write(key: "jwt", value: jwt);
                        context.go('/home');
                      } else {
                        displayDialog(
                            context, "Incorrect Password", "Try again.");
                      }
                    },
                    child: Text("Log In")),
              ),
              // button that pulls up the sign up card
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      // show the sign up card
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SignUpCard();
                          });
                    },
                    child: Text("Sign Up")),
              ),
            ],
          ),
        ));
  }
}
