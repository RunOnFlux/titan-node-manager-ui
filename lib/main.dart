// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:testapp/api/model/info.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/settings.dart';

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

// Using a package called Provider
// Inside the app we create a change notifier
// This is async fetch the data
// Don't fetch data outside of a widget

// Create a base widget which we have MyApp
// Change notifier goes and fetches the data that we want

// Once the change notifier has the data - change flag to not loading

// Widgets look at the notifier flag for loading and behave accordingly.

void main() async {
  GetIt.I.registerSingleton<NodeManagerInfo>(NodeManagerInfo());
  await NodeManagerSettings().initialize();

  runApp(NodeManagerApp());
}
