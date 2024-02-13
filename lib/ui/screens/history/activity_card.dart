import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/screens/home/save_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:testapp/api/model/history.dart';
import 'package:testapp/ui/components/generic_card.dart';
import 'package:intl/intl.dart';

class NodeActivity extends StatelessWidget with GetItMixin {
  NodeActivity(this.nodeActivity);

  final List<NodeEvent> nodeActivity;
  @override
  Widget build(BuildContext context) {
    final History history =
        watchOnly((NodeManagerInfo nodeManagerInfo) => nodeManagerInfo.history);
    return NodeActivityCard(nodeActivity);
  }
}

class NodeActivityCard  extends StatelessWidget{
  final List<NodeEvent> nodeActivity;
  NodeActivityCard(this.nodeActivity);

  List<Container> _buildRows() {
    List<Container> rows = [];
    for (var i = 0; i < nodeActivity.length; i++) {
      rows.add(Container(
        child: NodeEventCard(nodeActivity[i]),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildRows(),
    );
  }
}

class NodeEventCard extends StatelessWidget{
  final NodeEvent nodeEvent;
  const NodeEventCard(this.nodeEvent, {super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Timestamp')),
        DataColumn(label: Text('Provider')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('IP')),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text(convertTimeStamp(nodeEvent.timestamp))),
            DataCell(Text(nodeEvent.provider)),
            DataCell(Text(nodeEvent.name)),
            DataCell(Text(nodeEvent.ip)),
          ],
        ),
      ],
    );
  }

  // convert timestamp to date
  String convertTimeStamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  // Format DateTime
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    return formattedDate;
  }
}
