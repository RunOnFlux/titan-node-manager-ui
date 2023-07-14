import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';

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
  print('inside buildDataTable');
  return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      columns: const [
        DataColumn2(
          label: Text('IP Address'),
        ),
        DataColumn2(
          label: Text('Tier'),
        ),
        DataColumn2(
          label: Text('Rank'),
        ),
      ],
      rows: nodelist
          .map<DataRow>(
            (node) => buildDataRow(node),
          )
          .toList());
}

DataRow buildDataRow(node) {
  DataRow dataRow = DataRow(cells: [
    // DataCell(Text(node.collateral),),
    // DataCell(Text(node.txhash),),
    // DataCell(Text(node.outidx),),
    DataCell(
      Text(node.ip),
    ),
    // DataCell(
    //   Text(node.network),
    // ),
    // DataCell(Text(node.added_height.toString()),),
    // DataCell(Text(node.confirmed_height.toString()),),
    // DataCell(Text(node.last_confirmed_height.toString()),),
    // DataCell(Text(node.last_paid_height.toString()),),
    DataCell(
      Text(node.tier),
    ),
    // DataCell(Text(node.payment_address),),
    // DataCell(Text(node.pubkey),),
    // DataCell(Text(node.activesince),),
    // DataCell(Text(node.lastpaid),),
    // DataCell(Text(node.amount),),
    DataCell(
      Text(node.rank.toString()),
    ),
    // DataCell(Text(node.satoshis.toString()),),
    // DataCell(Text(node.height.toString()),),
    // DataCell(Text(node.confirmations.toString()),),
    // DataCell(Text(node.scriptPubKey),),
  ]);
  return dataRow;
}
