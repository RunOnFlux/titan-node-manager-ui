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

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];

    // reverse list so newest events are at the top
    for (var i = nodeActivity.length - 1; i >= 0; i--) {
      rows.add(nodeEventRow(nodeActivity[i]),);
    }
    return rows;
  }

  DataTable _buildDataTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Time')),
        DataColumn(label: Text('Provider')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('IP')),
      ],
      rows: _buildRows(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDataTable();
  }


  DataCell timeDataCell(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    
    // Format DateTime
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

    bool isWithin24Hours = DateTime.now().difference(date).inHours < 24;
    Color textColor = isWithin24Hours ? Colors.red : Colors.grey;
    return
        DataCell(Text(formattedDate, style: TextStyle(color: textColor)));
  }

  DataCell ipDataCell(String ip) {
    return DataCell(
      InkWell(
        onTap: () async {
          // Splitting the IP address and port, and handling the case where no port is specified
          var parts = ip.split(':');
          String ipPart = parts[0];
          String port = parts.length > 1 ? parts[1] : '16126'; // Defaulting to port 16126 if not specified
          String url = 'http://$ipPart:$port/';

          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Text(ip, style: TextStyle(color: Colors.blue)), // Styling the text to look clickable
      ),
    );

  }
  DataRow nodeEventRow(NodeEvent nodeEvent) {
    return DataRow(
      cells: [
        timeDataCell(nodeEvent.timestamp),
        DataCell(Text(nodeEvent.provider)),
        DataCell(Text(nodeEvent.name)),
        ipDataCell(nodeEvent.ip),
      ],
    );
  }
}







// class NodeActivity extends StatelessWidget with GetItMixin {
//   NodeActivity(this.nodeActivity);

//   final List<NodeEvent> nodeActivity;
//   @override
//   Widget build(BuildContext context) {
//     final History history =
//         watchOnly((NodeManagerInfo nodeManagerInfo) => nodeManagerInfo.history);
//     return NodeActivityCard(nodeActivity);
//   }
// }

// class NodeActivityCard  extends StatelessWidget{
//   final List<NodeEvent> nodeActivity;
//   NodeActivityCard(this.nodeActivity);

//   List<Container> _buildRows() {
//     List<Container> rows = [];
//     for (var i = 0; i < nodeActivity.length; i++) {
//       rows.add(Container(
//         child: NodeEventCard(nodeActivity[i]),
//       ));
//     }
//     return rows;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: _buildRows(),
//     );
//   }
// }

// class NodeEventCard extends StatelessWidget{
//   final NodeEvent nodeEvent;
//   const NodeEventCard(this.nodeEvent, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//       columns: [
//         DataColumn(label: Text('Time')),
//         DataColumn(label: Text('Provider')),
//         DataColumn(label: Text('Name')),
//         DataColumn(label: Text('IP')),
//       ],
//       rows: [
//         DataRow(
//           cells: [
//             timeDataCell(nodeEvent.timestamp),
//             DataCell(Text(nodeEvent.provider)),
//             DataCell(Text(nodeEvent.name)),
//             ipDataCell(nodeEvent.ip),
//           ],
//         ),
//       ],
//     );
//   }

//   DataCell timeDataCell(int timestamp) {
//     DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    
//     // Format DateTime
//     String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

//     bool isWithin24Hours = DateTime.now().difference(date).inHours < 24;
//     Color textColor = isWithin24Hours ? Colors.red : Colors.grey;
//     return
//         DataCell(Text(formattedDate, style: TextStyle(color: textColor)));
//   }

// DataCell ipDataCell(String ip) {
//   return DataCell(
//     InkWell(
//       onTap: () async {
//         // Splitting the IP address and port, and handling the case where no port is specified
//         var parts = ip.split(':');
//         String ipPart = parts[0];
//         String port = parts.length > 1 ? parts[1] : '16126'; // Defaulting to port 16126 if not specified
//         String url = 'http://$ipPart:$port/';

//         if (await canLaunchUrl(Uri.parse(url))) {
//           await launchUrl(Uri.parse(url));
//         } else {
//           throw 'Could not launch $url';
//         }
//       },
//       child: Text(ip, style: TextStyle(color: Colors.blue)), // Styling the text to look clickable
//     ),
//   );
// }

// }
