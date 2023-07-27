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
      child: _MyDataTable(nodeinfo),
    );
  }
}

class _MyDataTable extends StatefulWidget {
  final List<NodeInfo> nodeinfo; // Add this line to receive nodeinfo

  _MyDataTable(this.nodeinfo); // Constructor to receive nodeinfo;
  @override
  _MyDataTableState createState() => _MyDataTableState(nodeinfo);
}

// Work below //
class _MyDataTableState extends State<_MyDataTable> {
  _MyDataTableState(this.nodeinfo);
  List<NodeInfo> nodeinfo;

  List<DataRow> allDataRows = [];
  List<DataRow> filteredRows = [];

  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    allDataRows = nodeinfo
        .map<DataRow>((node) => buildDataRow(node, attributes))
        .toList();
    filteredRows = List.from(allDataRows);
  }

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() => filteredRows = allDataRows);
    } else {
      setState(() {
        filteredRows = allDataRows.where((row) {
          String rowContent = row.cells.map((cell) {
            if (cell.child is Text) {
              return (cell.child as Text).data!;
            } else if (cell.child is InkWell) {
              return ((cell.child as InkWell).child as Text).data!;
            } else {
              return ''; // or some default value
            }
          }).join(' ');

          return rowContent.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  List<Map<String, dynamic Function(dynamic)>> attributes = [
    {'IP Address': (node) => node.ip},
    {'Txhash': (node) => node.txhash},
    {'Tier': (node) => node.tier},
    {'Rank': (node) => node.rank.toString()},
    {'Added Height': (node) => node.added_height.toString()},
    {'Confirmed Height': (node) => node.confirmed_height.toString()},
  ];

  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(children: [
      SizedBox(
          child: TextField(
        onChanged: filterData, // Filter the data when the search query changes.
        decoration: const InputDecoration(
          labelText: "Search",
          suffixIcon: Icon(Icons.search),
        ),
      )),
      SizedBox(height: 600, child: buildDataTable())
    ]);
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      // Sort the data based on the selected column and sorting direction
      filteredRows.sort((a, b) {
        final aValue = (a.cells[columnIndex].child as Text).data!;
        final bValue = (b.cells[columnIndex].child as Text).data!;

        bool isNumeric =
            num.tryParse(aValue) != null && num.tryParse(bValue) != null;

        if (isNumeric) {
          double aNumber = double.parse(aValue);
          double bNumber = double.parse(bValue);
          return ascending
              ? aNumber.compareTo(bNumber)
              : bNumber.compareTo(aNumber);
        } else {
          return ascending
              ? Comparable.compare(aValue, bValue)
              : Comparable.compare(bValue, aValue);
        }
      });
    });
  }

  DataTable2 buildDataTable() {
    return DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: attributes
            .map((attribute) => DataColumn2(
                  label: Text(attribute.keys.first),
                  onSort: (columnIndex, ascending) =>
                      _onSort(columnIndex, ascending),
                ))
            .toList(),
        rows: filteredRows);
  }

  DataRow buildDataRow(node, attributes) {
    return DataRow(
      cells: attributes.map<DataCell>((attribute) {
        // attribute.values.first is a function that retrieves an attribute of the node
        var extractFeature = attribute.values.first;
        // Create ip hyperlink
        if (attribute.keys.first == 'IP Address') {
          return DataCell(
            InkWell(
              child: Text(
                extractFeature(node),
                style: const TextStyle(color: Colors.lightBlue),
              ),
              onTap: () async {
                String ip = extractFeature(node);
                String url = '';
                if (ip.contains(':')) {
                  url = 'http://${ip.split(':')[0]}/16126';
                } else {
                  url = 'http://${ip}:16126/';
                }
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
              extractFeature(node),
              style: const TextStyle(color: Colors.green),
            ),
          );
        }
      }).toList(),
    );
  }
}
