// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:testapp/api/model/info.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/settings.dart';

// class MyApp extends StatelessWidget {
//   final Info processedInfo;
//   final List<NodeInfo> nodeInfoList;
//   final Table nodeTable;

//   const MyApp(
//       {required this.processedInfo,
//       required this.nodeInfoList,
//       required this.nodeTable,
//       super.key});

//   static const double determinedHeight = 200;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: const Text('Nodes'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: ListView(
//             children: [
//               ...displayInfoProperties(processedInfo, nodeInfoList),
//               nodeTable,
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.add),
//           onPressed: () {
//             print('Clicked');
//           },
//         ),
//         persistentFooterButtons: <Widget>[
//           TextButton(
//             onPressed: () {},
//             child: const Text('Button 1'),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: const Text('Button 2'),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: const Text('Button 3'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// List<Widget> displayInfoProperties(Info info, List<NodeInfo> nodeInfoList) {
//   print('displaying');
//   return [
//     Text('Total Flux running: ${info.runningFlux}'),
//     Text('Total Flux offline: ${info.inactiveFlux}'),
//     Text('Nodes running: ${info.active}'),
//     Text('Nodes offline: ${info.inactive}'),
//     Text('Cumulus nodes running: ${info.cumulus}'),
//     Text('Nimbus nodes running: ${info.nimbus}'),
//     Text('Stratus nodes running: ${info.stratus}'),
//     Text('Next Payment Window: ${info.nextPaymentWindow}'),
//     Text('Node Info: ${nodeInfoList[0].confirmations}'),
//   ];
// }

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
