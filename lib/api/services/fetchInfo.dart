import 'dart:convert';
import 'dart:io';
import 'package:testapp/api/model/info.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/ui/screens/inactive/inactive_screen.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:get_it/get_it.dart';



class InfoService {
  Future<Info?> fetchInfo() async {
    final url = Uri.parse('http://localhost:4444/api/info');
    final token = GetIt.I<NodeManagerInfo>().token;

    try {
      print('before response');
      final response = await http.get(url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json", 
          HttpHeaders.authorizationHeader: "Bearer $token"});
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
    final url = Uri.parse('http://localhost:4444/api/nodeinfo');
    final token = GetIt.I<NodeManagerInfo>().token;

    try {
      final response = await http.get(url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json", 
          HttpHeaders.authorizationHeader: "Bearer $token"});
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
  //   final url = Uri.parse('http://localhost:4444/api/nodeinfo');
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

  // Future<InactiveInfo>
  // Future<List<InactiveInfo>> fetchInactiveInfo() async {
  //   List<InactiveInfo> inactiveList = [];
  //   final response =
  //       await http.get(Uri.parse('http://localhost:4444/api/inactive'));
  //   final data = response.body;
  //   final jsonData = jsonDecode(data);
  //   var values = jsonData.values;
  //   inactiveList = List<InactiveInfo>.from(
  //       values.map((model) => InactiveInfo.fromJson(model)));
  //   return inactiveList;
  // }

  // Future<List<DeepInfo>> fetchDeepNodes() async {
  //   List<DeepInfo> deepList = [];
  //   final response =
  //       await http.get(Uri.parse('http://localhost:4444/api/deepnode'));
  //   final data = response.body;
  //   final jsonData = jsonDecode(data);
  //   var values = jsonData.values;
  //   deepList =
  //       List<DeepInfo>.from(values.map((model) => DeepInfo.fromJson(model)));
  //   return deepList;
  // }
}
