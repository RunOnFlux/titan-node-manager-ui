// create a popup that asks for a username, password, and paymentaddress

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:go_router/go_router.dart';
import 'package:testapp/utils/address_validator.dart';
import 'package:testapp/utils/config.dart';
import 'dart:convert';

class SignUpCard extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<int> attemptSignUp(
      String username, String password, String address) async {
    var url = Uri.parse('${AppConfig().apiEndpoint}/signup');
    var res = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
          {"username": username, "password": password, "address": address}),
    );
    return res.statusCode;
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      // change the height of this

      content: Column(
        children: [
          SizedBox(height: 16),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Payment Address'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isValidFluxMainnetAddress(_addressController.text) == false) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Invalid payment address'),
                ));
                return;
              }
              attemptSignUp(_usernameController.text, _passwordController.text,
                      _addressController.text)
                  .then((statusCode) {
                if (statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Sign up successful'),
                  ));
                  Navigator.pop(context);
                  context.go('/');
                } else if (statusCode == 409) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Username already exists'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Sign up failed'),
                  ));
                }
              });
            },
            child: Text('Sign Up'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
