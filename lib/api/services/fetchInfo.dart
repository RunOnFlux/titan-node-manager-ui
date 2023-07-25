import 'dart:convert';
import 'dart:io';
import 'package:testapp/api/model/info.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/ui/screens/inactive/inactive_screen.dart';

class InfoService {
  Future<Info> fetchInfo() async {
    final response =
        await http.get(Uri.parse('http://localhost:4444/api/info'));
    final data = response.body;
    final jsonData = jsonDecode(data);

    final infoFuture = Info.fromJson(jsonData);
    return infoFuture;
  }

  Future<List<NodeInfo>> fetchNodeInfo() async {
    final response =
        await http.get(Uri.parse('http://localhost:4444/api/nodeinfo'));
    final data = response.body;

    Iterable l = jsonDecode(data);
    List<NodeInfo> nodeinfolist =
        List<NodeInfo>.from(l.map((model) => NodeInfo.fromJson(model)));

    return nodeinfolist;
  }

  // Future<InactiveInfo>
  Future<List<InactiveInfo>> fetchInactiveInfo() async {
    List<InactiveInfo> inactiveList = [];
    final response =
        await http.get(Uri.parse('http://localhost:4444/api/inactive'));
    final data = response.body;
    final jsonData = jsonDecode(data);
    var values = jsonData.values;
    inactiveList = List<InactiveInfo>.from(
        values.map((model) => InactiveInfo.fromJson(model)));
    return inactiveList;
  }
}
