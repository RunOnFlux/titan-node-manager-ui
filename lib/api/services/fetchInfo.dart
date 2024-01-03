import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:testapp/api/model/info.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/ui/screens/inactive/inactive_screen.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/screens/login/login_card.dart';
import 'package:testapp/utils/config.dart';

class InfoService {
  Future<String> get jwtOrEmpty async {
    final String? jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  Future<Info?> fetchInfo() async {
    final url = Uri.parse('${AppConfig().apiEndpoint}/info');
    // final token = GetIt.I<NodeManagerInfo>().token;
    final token = await jwtOrEmpty;

    try {
      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
      if (response.statusCode == 200) {
        final data = response.body;
        final jsonData = jsonDecode(data);
        final infoFuture = Info.fromJson(jsonData);
        return infoFuture;
      } else if (response.statusCode == 401) {
        print('401: Invalid credentials');
        return null;
      } else {
        print('Failed to retrieve requested info');
        return null;
      }
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  Future<List<NodeInfo>?> fetchNodeInfo() async {
    final url = Uri.parse('${AppConfig().apiEndpoint}/nodeinfo');
    final token = await jwtOrEmpty;

    try {
      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
      if (response.statusCode == 200) {
        final data = response.body;
        Iterable l = jsonDecode(data);
        List<NodeInfo> nodeinfolist =
            List<NodeInfo>.from(l.map((model) => NodeInfo.fromJson(model)));
        return nodeinfolist;
      } else if (response.statusCode == 401) {
        print('401: Invalid credentials');
        return null;
      } else {
        print('Failed to retrieve requested info');
        return null;
      }
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  //   Future<List<InactiveInfo>?> fetchInactiveInfo() async {
  //   final url = Uri.parse('https://managerbackend/api/nodeinfo');
  //   final token = GetIt.I<NodeManagerInfo>().token;

  //   try {
  //     final response = await http.get(url,
  //         headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //         HttpHeaders.authorizationHeader: "Bearer $token"});
  //     if (response.statusCode == 200) {
  //       List<InactiveInfo> inactiveList = [];
  //       final data = response.body;
  //       final jsonData = jsonDecode(data);
  //       var values = jsonData.values;
  //       inactiveList = List<InactiveInfo>.from(
  //         values.map((model) => InactiveInfo.fromJson(model)));
  //       return inactiveList;
  //     } else if (response.statusCode == 401) {
  //       print('401: Invalid credentials');
  //       return null;
  //     } else {
  //       print('Failed to retrieve requested info');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('error: $e');
  //     return null;
  //   }
  // }
}
