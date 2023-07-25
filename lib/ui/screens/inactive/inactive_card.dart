import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/api/services/fetchInfo.dart';
import 'package:http/http.dart' as http;

import 'package:data_table_2/data_table_2.dart';

class InactiveCard extends StatelessWidget with GetItMixin {
  InactiveCard({super.key});
  @override
  Widget build(BuildContext context) {
    var inactiveInfo =
        watchOnly((NodeManagerInfo inactiveInfo) => inactiveInfo.inactiveInfo);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: buildDataTable(inactiveInfo),
    );
  }
}

DataTable2 buildDataTable(nodelist) {
  List<Map<String, dynamic Function(dynamic)>> attributes = [
    // {'Address': (node) => node.address},
    {'Txhash': (node) => node.txid},
    // {'Vout': (node) => node.vout},
    // {'ScriptPubKey': (node) => node.scriptPubKey},
    {'Amount': (node) => node.amount.toString()},
    {'Satoshis': (node) => node.satoshis.toString()},
    {'Height': (node) => node.height.toString()},
    {'Confirmations': (node) => node.confirmations.toString()},
  ];

  return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      columns: [const DataColumn(label: Text(''))] +
          attributes
              .map((attribute) => DataColumn2(
                    label: Text(attribute.keys.first),
                  ))
              .toList(),
      rows: nodelist
          .map<DataRow>(
            (node) => buildDataRow(node, attributes),
          )
          .toList());
}

DataRow buildDataRow(node, attributes) {
  var startCell = DataCell(startNodeButton(node));
  DataRow dataRow = DataRow(
      cells: [startCell] +
          attributes
              .map<DataCell>((attribute) => DataCell(
                    Text(attribute.values.first(node),
                        style: const TextStyle(color: Colors.red)),
                  ))
              .toList());
  return dataRow;
}

ElevatedButton startNodeButton(node) {
  // startNode(node);
  var button = ElevatedButton(
    child: const Text('Start Fluxnode'),
    onPressed: () {
      var response = startNode(node);
      print('response body: ${response}');
    },
  );
  return button;
}

Future<http.Response> startNode(node) async {
  var txhash = node.txid;
  var outidx = node.vout;

  Map<String, dynamic> requestBody = {
    'txhash': txhash,
    'outidx': outidx,
  };
  print('startNode: \n txhash-->${txhash} \n body-->$requestBody');
  var url = Uri.parse('http://localhost:4444/api/startnode');
  print(url);
  final response = await http.post(
    url,
    body: jsonEncode(requestBody),
    headers: {'Content-Type': 'application/json'},
  );
  print('response body in startNode: ${response.body}');
  return response;
}
