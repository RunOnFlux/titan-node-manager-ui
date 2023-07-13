// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:testapp/api/model/info.dart';
import 'package:testapp/api/model/nodeinfo.dart';

class MyApp extends StatelessWidget {
  final Info processedInfo;
  final List<NodeInfo> nodeInfoList;
  const MyApp(
      {required this.processedInfo, required this.nodeInfoList, super.key});

  static const double determinedHeight = 200;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Nodes'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...displayInfoProperties(processedInfo, nodeInfoList),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print('Clicked');
          },
        ),
        persistentFooterButtons: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Button 1'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Button 2'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Button 3'),
          ),
        ],
      ),
    );
  }
}

// Returns object containing macro info
Future<Info> fetchInfo() async {
  final response = await http.get(Uri.parse('http://localhost:4444/api/info'));
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

Future<List<NodeInfo>> fetchNodes() async {
  final response =
      await http.get(Uri.parse('http://localhost:4444/api/nodeinfo'));
  final data = response.body;
  final jsonData = jsonDecode(data);

  Iterable l = jsonDecode(data);
  List<NodeInfo> nodeinfolist =
      List<NodeInfo>.from(l.map((model) => NodeInfo.fromJson(model)));

  return nodeinfolist;
}

List<Widget> displayInfoProperties(Info info, List<NodeInfo> nodeInfoList) {
  print('displaying');
  return [
    Text('Total Flux running: ${info.runningFlux}'),
    Text('Total Flux offline: ${info.inactiveFlux}'),
    Text('Nodes running: ${info.active}'),
    Text('Nodes offline: ${info.inactive}'),
    Text('Cumulus nodes running: ${info.cumulus}'),
    Text('Nimbus nodes running: ${info.nimbus}'),
    Text('Stratus nodes running: ${info.stratus}'),
    Text('Next Payment Window: ${info.nextPaymentWindow}'),
    Text('Node Info: ${nodeInfoList[0].collateral}'),
  ];
}

void main() async {
  final processedInfo = await fetchInfo();
  final nodeInfoList = await fetchNodes();
  print('in main, done processing');

  runApp(MyApp(
    processedInfo: processedInfo,
    nodeInfoList: nodeInfoList,
  ));
}
