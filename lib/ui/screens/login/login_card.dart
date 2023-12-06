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


import 'package:testapp/api/services/fetchInfo.dart';



final storage = FlutterSecureStorage();

class LoginPage extends StatelessWidget with GetItMixin{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: Text(text)
        ),
    );

  Future<String?> attemptLogIn(String username, String password) async {

    var uri = Uri.parse('http://localhost:4444/api/login');
    print('username: $username');
    print('password: $password');
    var res = await http.post(
      uri,
      headers: {
        // "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode({
        "username": username,
        "password": password
      })
    );
    var token = res.body;
    print('token: $token');
    
    if(res.statusCode == 200) {
      GetIt.I<NodeManagerInfo>().setToken(token);
      // fetch data again
      var info = await InfoService().fetchInfo();
      var nodeinfo = await InfoService().fetchNodeInfo();
      // var inactiveInfo = await InfoService().fetchInactiveInfo();
      // print('getit info ${GetIt.I<NodeManagerInfo>().info}');

      GetIt.I<NodeManagerInfo>().info = info!;
      GetIt.I<NodeManagerInfo>().nodeinfo = nodeinfo!;
      // GetIt.I<NodeManagerInfo>().inactiveInfo = inactiveInfo!;
      // GetIt.I<NodeManagerInfo>().lastRefresh = info.time;

      return res.body;}
    return null;
  }

  Future<int> attemptSignUp(String username, String password) async {
    var uri = Uri.parse('http://localhost:4444/api/signup');
    print('username: $username');
    print('password: $password');
    var res = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: {
        "username": username,
        "password": password
      }
    );
    return res.statusCode;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log In"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username'
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password'
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var username = _usernameController.text;
                var password = _passwordController.text;
                var jwt = await attemptLogIn(username, password);
                if(jwt != null) {
                  storage.write(key: "jwt", value: jwt);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage.fromBase64(jwt)
                    )
                  );
                } else {
                  displayDialog(context, "Incorrect Password", "Try again.");
                }
              },
              child: Text("Log In")
            ),
            ElevatedButton(
              onPressed: () async {
                var username = _usernameController.text;
                var password = _passwordController.text;

                if(username.length < 4) 
                  displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                else if(password.length < 4) 
                  displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                else{
                  var res = await attemptSignUp(username, password);
                  if(res == 201)
                    displayDialog(context, "Success", "The user was created. Log in now.");
                  else if(res == 409)
                    displayDialog(context, "That username is already registered", "Please try to sign up using another username or log in if you already have an account.");  
                  else {
                    displayDialog(context, "Error", "An unknown error occurred.");
                  }
                }
              },
              child: const Text("Sign Up")
            )
          ],
        ),
      )
    );
  }
}


class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);
  
  factory HomePage.fromBase64(String jwt) =>
    HomePage(
      jwt,
      json.decode(
        ascii.decode(
          base64.decode(base64.normalize(jwt.split(".")[1]))
        )
      )
    );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(title: Text("Secret Data Screen")),
      body: Center(
        child: HomeScreen(),
        // FutureBuilder(
        //   future: http.read(Uri.parse('http://localhost:4444/api/data'), headers: {"authorization": jwt}),
        //   builder: (context, snapshot) =>
        //     snapshot.hasData ?
        //     Column(children: <Widget>[
        //       Text("${payload['username']}, here's the data:"),
        //       Text(snapshot.data!, style: Theme.of(context).textTheme.headlineMedium)
        //     ],)
        //     :
        //     snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
        // ),
      ),
    );
}
