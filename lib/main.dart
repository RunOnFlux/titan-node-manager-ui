// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Info {
  final int runningFlux;
  final int inactiveFlux;
  final int activeNodes;
  final int inactiveNodes;
  final int cumulus;
  final int nimbus;
  final int stratus;
  final int nextPaymentWindow;

  Info({
    this.runningFlux = 0,
    this.inactiveFlux = 0,
    this.activeNodes = 0,
    this.inactiveNodes = 0,
    this.cumulus = 0,
    this.nimbus = 0,
    this.stratus = 0,
    this.nextPaymentWindow = 0,
  });

  @override
  String toString() {
    String string =
        'runningFlux: $runningFlux \n inactiveFlux: $inactiveFlux \n activeNodes: $activeNodes \n inactiveNodes: $inactiveNodes \n cumulus:  $cumulus \n nimbus: $nimbus \n stratus: $stratus \n nextPayWindow: $nextPaymentWindow';
    return string;
  }
}

class MyApp extends StatelessWidget {
  final Info processedInfo;
  const MyApp({required this.processedInfo, super.key});

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
                ...displayInfoProperties(processedInfo),
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

// converts object of type _jsonmap to Info
Info objectToInfo(dynamic object) {
  print('Running objectoinfo');
  try {
    Info info = Info(
      runningFlux: object['runningFlux'],
      inactiveFlux: object['inactiveFlux'],
      activeNodes: object['active'],
      inactiveNodes: object['inactive'],
      cumulus: object['cumulus'],
      nimbus: object['nimbus'],
      stratus: object['stratus'],
      nextPaymentWindow: object['nextPaymentWindow'],
    );
    return info;
  } on Exception catch (e) {
    print('error: $e');
    throw Error();
  }
}

// Returns object containing macro info
Future<Info> fetchInfo() async {
  final response = await http.get(Uri.parse('http://localhost:4444/api/info'));
  final data = response.body;
  final jsonData = jsonDecode(data);

  print(jsonData['runningFlux']);
  print('jsondata type ${jsonData.runtimeType}');

  final infoFuture = objectToInfo(jsonData);
  print('done converting');
  print(infoFuture.runningFlux);
  print('jsondata type ${infoFuture.runtimeType}');
  return infoFuture;
}

Future<List> fetchNodes() async {
  final response = await http.get(Uri.parse('http://localhost:4444/api/info'));
  final data = response.body;
  final jsonData = jsonDecode(data);
  return [];
}

List<Widget> displayInfoProperties(Info info) {
  print('displaying');
  return [
    Text('Total Flux running: ${info.runningFlux}'),
    Text('Total Flux offline: ${info.inactiveFlux}'),
    Text('Nodes running: ${info.activeNodes}'),
    Text('Nodes offline: ${info.inactiveNodes}'),
    Text('Cumulus nodes running: ${info.cumulus}'),
    Text('Nimbus nodes running: ${info.nimbus}'),
    Text('Stratus nodes running: ${info.stratus}'),
    Text('Next Payment Window: ${info.nextPaymentWindow}'),
  ];
}

void main() async {
  final processedInfo = await fetchInfo();
  print('in main, done processing');

  runApp(MyApp(
    processedInfo: processedInfo,
  ));
}
