import 'dart:convert';
import 'package:testapp/api/model/info.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/api/model/nodeinfo.dart';

class InfoService {
  // Returns object containing macro info
  Future<Info> fetchInfo() async {
    final response =
        await http.get(Uri.parse('http://localhost:4444/api/info'));
    final data = response.body;
    final jsonData = jsonDecode(data);

    print(jsonData['runningFlux']);
    print('jsondata type ${jsonData.runtimeType}');

    final infoFuture = Info.fromJson(jsonData);
    print('done converting');
    print(infoFuture.runningFlux);
    print('jsondata type ${infoFuture.runtimeType}');
    return infoFuture;
  }

  Future<List<NodeInfo>> fetchNodeInfo() async {
    final response =
        await http.get(Uri.parse('http://localhost:4444/api/nodeinfo'));
    final data = response.body;
    final jsonData = jsonDecode(data);

    Iterable l = jsonDecode(data);
    List<NodeInfo> nodeinfolist =
        List<NodeInfo>.from(l.map((model) => NodeInfo.fromJson(model)));

    return nodeinfolist;
  }
}
