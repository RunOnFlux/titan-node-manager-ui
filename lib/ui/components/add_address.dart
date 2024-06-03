import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'dart:convert';
import 'package:testapp/utils/config.dart';
import 'package:testapp/api/services/fetchInfo.dart';
import 'package:http/http.dart' as http;

import 'package:go_router/go_router.dart';

class AddAddress extends StatelessWidget with GetItMixin {
  final _addressController = TextEditingController();
  final VoidCallback rebuild;

  AddAddress({required this.rebuild});
  @override
  Widget build(BuildContext context) {
    return Card(
      // padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Column(
                          children: [
                            SizedBox(height: 16),
                            TextField(
                              controller: _addressController,
                              decoration:
                                  InputDecoration(labelText: 'Payment Address'),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              addAddress(
                                context,
                                _addressController.text,
                                rebuild,
                              );
                            },
                            child: Text('Confirm'),
                          ),
                          // cancel button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      ));
            },
            child: Text('Add Address'),
          ),
        ],
      ),
    );
  }

  Future<void> addAddress(BuildContext context, address, rebuild) async {
    print('running addAddress');
    var user = GetIt.I<NodeManagerInfo>().user;
    final url = Uri.parse('${AppConfig().apiEndpoint}/addaddress');
    final token = GetIt.I<NodeManagerInfo>().token;
    if (token == '') {
      print('Not logged in');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Not logged in'),
      ));
      return;
    }

    final response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
          'username': user,
        },
        body: jsonEncode({'address': address}));
    print('right after');
    print('Response: ${response}');
    print('responsebody: ${response.body}');
    print('Response code: ${response.statusCode}');
    if (response.statusCode == 201) {
      rebuild();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Address added'),
      ));
    }
  }
}
