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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/app.dart';

class InfoService {
  Future<String> get jwtOrEmpty async {
    final String? jwt = await storage.read(key: "jwt");
    print('jwt: $jwt');
    if (jwt == null) return "";
    return jwt;
  }

  // clear token
  Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    print('Deleting expired token');
    await storage.delete(key: "jwt");
    prefs.remove('info');
    prefs.remove('nodeinfo');
    prefs.remove('inactiveInfo');
    prefs.remove('history');
    GetIt.I<NodeManagerInfo>().isLoggedIn = false;
    GetIt.I<NodeManagerInfo>().isInfoFetched = false;
  }

  // check if token is expired
  Future<bool> tokenIsActive(String? jwt) async {
    print('Checking token');
    if (jwt == null) {
      print('Token is null');
      return false;
    }
    final url = Uri.parse('${AppConfig().apiEndpoint}/verify');
    try {
      print('before response');
      final response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      });
      print('after response');

      print('response: ${response}');
      print('response status code: ${response.statusCode}');
      // clearToken();

      if (response.statusCode == 200) {
        print('Token is active');
        return true;
      } else {
        print('Token is expired');
        GetIt.I<NodeManagerInfo>().logout();
        await clearToken();
        return false;
      }
    } catch (e) {
      print('Error in checktoken: $e');
      GetIt.I<NodeManagerInfo>().logout();

      await clearToken();
      return false;
    }
  }

  Future<bool> checkLogin() async {
    final String? jwt = await storage.read(key: "jwt");
    final bool tokenIsActive = await this.tokenIsActive(jwt);
    var isTokenValid = GetIt.I<NodeManagerInfo>().isLoggedIn;

    print('Checktoken result: $tokenIsActive');
    if (jwt == null || tokenIsActive == false) {
      print('Token is null or expired');
      GetIt.I<NodeManagerInfo>().isLoggedIn = false;
      isTokenValid = false;
    } else {
      print('Token is valid in fetchInfo');
      GetIt.I<NodeManagerInfo>().isLoggedIn = true;
      isTokenValid = true;
      GetIt.I<NodeManagerInfo>().setToken(jwt);
    }

    bool isInfoFetched = GetIt.I<NodeManagerInfo>().isInfoFetched;
    if (isTokenValid && !isInfoFetched) {
      await fetchInfo();
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return isTokenValid;
  }

  Future<bool> fetchInfo() async {
    print('Fetching info ');
    // if there is data in persistent storage, fetch from there
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // only pull from storage if the data is not stale
    if (prefs.getString('info') != null) {
      print('Info is not null');
      await fetchInfoFromStorage(prefs);
      final lastRefresh = GetIt.I<NodeManagerInfo>().info.time;

      final now = DateTime.now().millisecondsSinceEpoch;
      final secondsElapsed = ((now - lastRefresh) / 1000).floor();

      print('Seconds elapsed: $secondsElapsed');
      if (secondsElapsed < 120) {
        print('Info is not stale');
        return true;
      }
    }
    print('Info is stale');
    await fetchInfoFromServer(prefs);

    return true;
  }

  // fetch info from persistent storage
  Future<void> fetchInfoFromStorage(prefs) async {
    final info = prefs.getString('info');
    final nodeinfo = prefs.getString('nodeinfo');
    final inactiveInfo = prefs.getString('inactiveInfo');
    final history = prefs.getString('history');

    if (info == null ||
        nodeinfo == null ||
        inactiveInfo == null ||
        history == null) {
      print('Failed to fetch data from storage');
      return;
    }

    // Save to session storage
    GetIt.I<NodeManagerInfo>().info = Info.fromJson(jsonDecode(info));
    GetIt.I<NodeManagerInfo>().nodeinfo = List<NodeInfo>.from(
        jsonDecode(nodeinfo).map((model) => NodeInfo.fromJson(model)));
    GetIt.I<NodeManagerInfo>().inactiveInfo = List<InactiveInfo>.from(
        jsonDecode(inactiveInfo).map((model) => InactiveInfo.fromJson(model)));
    GetIt.I<NodeManagerInfo>().history = History.fromJson(jsonDecode(history));
    GetIt.I<NodeManagerInfo>().isInfoFetched = true;
  }

  // fetch info from server
  Future<void> fetchInfoFromServer(prefs) async {
    print('Fetching info from server');
    var info = await fetchMacroInfo();
    var nodeinfo = await fetchNodeInfo();
    var inactiveInfo = await fetchInactiveInfo();
    var history = await fetchHistory();

    if (info == null ||
        nodeinfo == null ||
        inactiveInfo == null ||
        history == null) {
      print('Failed to fetch data');
      return;
    }

    // Save to session storage
    GetIt.I<NodeManagerInfo>().info = info;
    GetIt.I<NodeManagerInfo>().nodeinfo = nodeinfo;
    GetIt.I<NodeManagerInfo>().inactiveInfo = inactiveInfo;
    GetIt.I<NodeManagerInfo>().history = history;
    // GetIt.I<NodeManagerInfo>().lastRefresh = info.time;

    // Save to persistent storage
    prefs.setString('info', jsonEncode(info));
    prefs.setString('nodeinfo', jsonEncode(nodeinfo));
    prefs.setString('inactiveInfo', jsonEncode(inactiveInfo));
    prefs.setString('history', jsonEncode(history));
    GetIt.I<NodeManagerInfo>().isInfoFetched = true;
  }

  Future<void> updateCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final info = GetIt.I<NodeManagerInfo>().info;
    final nodeinfo = GetIt.I<NodeManagerInfo>().nodeinfo;
    final inactiveInfo = GetIt.I<NodeManagerInfo>().inactiveInfo;
    final history = GetIt.I<NodeManagerInfo>().history;

    prefs.setString('info', jsonEncode(info));
    prefs.setString('nodeinfo', jsonEncode(nodeinfo));
    prefs.setString('inactiveInfo', jsonEncode(inactiveInfo));
    prefs.setString('history', jsonEncode(history));
  }

  Future<Info?> fetchMacroInfo() async {
    final url = Uri.parse('${AppConfig().apiEndpoint}/info');
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
    } catch (e) {
      ;
      print('error: $e');
      return null;
    }
  }

  Future<History?> fetchHistory() async {
    final url = Uri.parse('${AppConfig().apiEndpoint}/history');
    final token = await jwtOrEmpty;

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
        print(
            'Failed to retrieve requested info with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error encountered: $e');

      return null;
    }
  }
}
