import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/utils/config.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/api/model/nodeinfo.dart';

import 'package:testapp/ui/screens/login/login_card.dart';

import 'package:flutter/services.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/config.dart';

Future<http.Response> saveNode(node, inputs, reset) async {
  var txhash = (node is NodeInfo)
      ? node.txhash
      : (node is InactiveInfo)
          ? node.txid
          : null;
  dynamic outidx;

  if (node is NodeInfo) {
    outidx = int.tryParse(node.outidx);
  } else if (node is InactiveInfo) {
    outidx = node.vout;
  }

  // start with 1 capital letter
  inputs['provider'] = inputs['provider'].substring(0, 1).toUpperCase() +
      inputs['provider'].substring(1).toLowerCase();

  Map<String, dynamic> requestBody = {
    'txhash': txhash,
    'outidx': outidx,
    'name': inputs['name'],
    'provider': inputs['provider'],
    'price': inputs['price'],
  };

  final String? jwt = await storage.read(key: "jwt");
  var url = Uri.parse('${AppConfig().apiEndpoint}/update');
  final response = await http.post(
    url,
    body: jsonEncode(requestBody),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $jwt"
    },
  );

  if (response.body == 'Update successful') {
    node.name = inputs['name'];
    node.provider = inputs['provider'];
    node.price = double.parse(inputs['price']);

    reset();
  } else {
    print('UPDATE FAILED');
  }

  return response;
}
