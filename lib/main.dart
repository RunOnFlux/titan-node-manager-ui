// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:testapp/api/model/info.dart';
import 'package:testapp/api/model/nodeinfo.dart';

class MyApp extends StatelessWidget {
  final Info processedInfo;
  final List<NodeInfo> nodeInfoList;
  final Table nodeTable;

  const MyApp(
      {required this.processedInfo,
      required this.nodeInfoList,
      required this.nodeTable,
      super.key});

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
          child: ListView(
            children: [
              ...displayInfoProperties(processedInfo, nodeInfoList),
              nodeTable,
            ],
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

TableRow buildRow(node) {
  TableRow tableRow = TableRow(children: [
    Text(node.collateral),
    Text(node.txhash),
    Text(node.outidx),
    Text(node.ip),
    Text(node.network),
    Text(node.added_height.toString()),
    Text(node.confirmed_height.toString()),
    Text(node.last_confirmed_height.toString()),
    Text(node.last_paid_height.toString()),
    Text(node.tier),
    Text(node.payment_address),
    Text(node.pubkey),
    Text(node.activesince),
    Text(node.lastpaid),
    Text(node.amount),
    Text(node.rank.toString()),
    Text(node.satoshis.toString()),
    Text(node.height.toString()),
    Text(node.confirmations.toString()),
    Text(node.scriptPubKey),
  ]);
  return tableRow;
}

Table buildTable(nodelist) {
  print('building table');
  final headers = [
    'collateral',
    'txhash',
    'outidx',
    'ip',
    'network',
    'added_height',
    'confirmed_height',
    'last_confirmed_height',
    'last_paid_height',
    'tier',
    'payment_address',
    'pubkey',
    'activesince',
    'pastpaid',
    'amount',
    'rank',
    'satoshis',
    'height',
    'confirmations',
    'scriptpubkey'
  ];
  final rows = nodelist.map<TableRow>((node) => buildRow(node)).toList();
  // rows.insert(0, headers);
  Table nodeTable = Table(
    children: rows,
  );
  return nodeTable;
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
    Text('Node Info: ${nodeInfoList[0].confirmations}'),
  ];
}

void main() async {
  final processedInfo = await fetchInfo();
  final nodeInfoList = await fetchNodes();
  print('nodeInfoList is type ${nodeInfoList.runtimeType}');
  final nodeTable = buildTable(nodeInfoList);
  print('nodetable: $nodeTable');
  print('in main, done processing');

  runApp(MyApp(
    processedInfo: processedInfo,
    nodeInfoList: nodeInfoList,
    nodeTable: nodeTable,
  ));
}
