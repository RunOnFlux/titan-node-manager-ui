import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:data_table_2/data_table_2.dart';

class NodeInfoCard extends StatelessWidget with GetItMixin {
  NodeInfoCard({super.key});
  @override
  Widget build(BuildContext context) {
    var nodeinfo = watchOnly((NodeManagerInfo nodeinfo) => nodeinfo.nodeinfo);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: buildDataTable(nodeinfo),
    );
  }
}

DataTable2 buildDataTable(nodelist) {
  List<Map<String, dynamic Function(dynamic)>> attributes = [
    {'IP Address': (node) => node.ip},
    {'Tier': (node) => node.tier},
    {'Rank': (node) => node.rank.toString()},
    // {'Collateral': (node) => node.collateral},
    {'Txhash': (node) => node.txhash},
    // {'Outidx': (node) => node.outidx},
    // {'Network': (node) => node.network},
    {'Added Height': (node) => node.added_height.toString()},
    {'Confirmed Height': (node) => node.confirmed_height.toString()},
    // {'Last Confirmed Height': (node) => node.last_confirmed_height.toString()},
    // {'Last Paid Height': (node) => node.last_paid_height.toString()},
    // {'Payment Address': (node) => node.payment_address},
    // {'Pubkey': (node) => node.pubkey},
    // {'Active Since': (node) => node.activesince},
    // {'Last Paid': (node) => node.lastpaid},
    // {'Amount': (node) => node.amount},
    // {'Satoshis': (node) => node.satoshis.toString()},
    // {'Height': (node) => node.height.toString()},
    // {'Confirmations': (node) => node.confirmations.toString()},
    // {'ScriptPubKey': (node) => node.scriptPubKey},
  ];

  return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      columns: attributes
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
  return DataRow(
    cells: attributes.map<DataCell>((attribute) {
      if (attribute.keys.first == 'IP Address') {
        return DataCell(
          InkWell(
            child: Text(
              attribute.values.first(node),
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () async {
              String ip = attribute.values.first(node);
              String url = '';
              print('ip--> $ip');
              if (ip.contains(':')) {
                print('Unique port detected (${ip.split(':')[1]})');
                url = 'http://${ip.split(':')[0]}/16126';
              } else {
                url = 'http://${ip}:16126/';
              }
              print('url: $url');
              if (await canLaunchUrl((Uri.parse(url)))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        );
      } else {
        return DataCell(
          Text(
            attribute.values.first(node),
            style: const TextStyle(color: Colors.green),
          ),
        );
      }
    }).toList(),
  );
}
