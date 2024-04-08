import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:testapp/utils/config.dart';

import 'package:flutter/foundation.dart';
import 'package:testapp/api/model/info.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/api/model/history.dart';

import 'package:testapp/ui/screens/login/login_card.dart';
import 'package:testapp/utils/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/app.dart';




class InfoService {
  Future<String> get jwtOrEmpty async {
    final String? jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  Future<void> fetchInfo() async {
    var info = await fetchMacroInfo();
    var nodeinfo = await fetchNodeInfo();
    var inactiveInfo = await fetchInactiveInfo();
    var history = await fetchHistory();

    print('info: $info');

    if (info == null || nodeinfo == null || inactiveInfo == null || history == null) {
      print('Failed to fetch data');
      return;
    }

    GetIt.I<NodeManagerInfo>().info = info!;
    GetIt.I<NodeManagerInfo>().nodeinfo = nodeinfo!;
    GetIt.I<NodeManagerInfo>().inactiveInfo = inactiveInfo!;
    GetIt.I<NodeManagerInfo>().history = history!;
    GetIt.I<NodeManagerInfo>().lastRefresh = info.time;
  }


  Future<Info?> fetchMacroInfo() async {
    final url = Uri.parse('${AppConfig().apiEndpoint}/info');
    print('Fetching from ${AppConfig().apiEndpoint}');
    print('Fetching MacroInfo');

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
    print('Fetching NodeInfo');

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

  Future<List<InactiveInfo>?> fetchInactiveInfo() async {
    final url = Uri.parse('${AppConfig().apiEndpoint}/inactive');
    final token = await jwtOrEmpty;
    print('Fetching InactiveInfo');

    try {
      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token"
      });
      if (response.statusCode == 200) {
        final data = response.body;
        Iterable l = jsonDecode(data);
        List<InactiveInfo> inactiveInfoList = List<InactiveInfo>.from(
            l.map((model) => InactiveInfo.fromJson(model)));
        return inactiveInfoList;
      } else if (response.statusCode == 401) {
        print('401: Invalid credentials for inactive info');
        return null;
      } else if (response.statusCode == 500) {
        print('500: failed to retrieve info');
        return null;
      } else {
        print('Failed to retrieve requested info');
        return null;
      }
    } catch (e) {;
      print('error: $e');
      return null;
    }
  }

Future<History?> fetchHistory() async {
  final url = Uri.parse('${AppConfig().apiEndpoint}/history');
  final token = await jwtOrEmpty;
  print('Fetching History');

  try {
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    if (response.statusCode == 200) {
      final data = response.body;
      final jsonData = jsonDecode(data);
      final history = History.fromJson(jsonData);
      return history;
    } else if (response.statusCode == 401) {
      print('401: Invalid credentials');
      return null;
    } else {
      print('Failed to retrieve requested info with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error encountered: $e');
    return null;
  }
}

}
