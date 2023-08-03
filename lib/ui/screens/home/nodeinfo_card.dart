import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:data_table_2/data_table_2.dart';

import 'info_prop_card.dart';

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
        .map<DataRow>((node) => buildDataRow(context, node, attributes))
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
          }).join('***'); // should change this

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
      Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
            width: 200,
            child: TextField(
              onSubmitted:
                  filterData, // Filter the data when the search query changes.
              decoration: const InputDecoration(
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
            )),
      ),
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

  DataRow buildDataRow(context, node, attributes) {
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
        // onSelectChanged: (bool? selected) {
        //   if (selected != null && selected) {
        //     displayPopout(node);
        //   }

        onLongPress: () => displayPopout(node));
  }

  void displayPopout(node) {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopoutCard(node: node);
          });
      // return true;
    } catch (err) {
      rethrow;
    }
  }
}

// Pops out when the node row is clicked
// Displays all information about the node
class PopoutCard extends StatelessWidget {
  final dynamic node;

  PopoutCard({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    // var nodeinfo = watchOnly((NodeManagerInfo nodeinfo) => nodeinfo.nodeinfo);
    print('what');
    List<Map<String, dynamic Function(dynamic)>> attributes = [
      {'IP Address': (node) => node.ip},
      {'Txhash': (node) => node.txhash},
      {'Tier': (node) => node.tier},
      {'Rank': (node) => node.rank.toString()},
      {'Added Height': (node) => node.added_height.toString()},
      {'Confirmed Height': (node) => node.confirmed_height.toString()},
      {
        'Last Confirmed Height': (node) => node.last_confirmed_height.toString()
      },
      {'Outidx': (node) => node.outidx},
      {'Network': (node) => node.network},
      {'Last Paid Height': (node) => node.tier.toString()},
      {'Payment Address': (node) => node.payment_address},
      // {'Pubkey': (node) => node.pubkey},
      {'Active Since': (node) => node.activesince},
      {'Last Paid': (node) => node.lastpaid},
      {'Amount': (node) => node.amount},
      {'Satoshis': (node) => node.satoshis.toString()},
      {'Height': (node) => node.height.toString()},
      {'Confirmations': (node) => node.confirmations.toString()},
      {'Scriptpubkey': (node) => node.scriptPubKey},
    ];

    return BootstrapContainer(
      // decoration: BoxDecoration(color: Color.fromARGB(255, 42, 67, 84)),
      // padding: EdgeInsets.all(10.0),
      fluid: false,
      children: [
        BootstrapRow(
            height: 560,
            children: attributes.map((attribute) {
              var extractFeature = attribute.values.first;
              return BootstrapCol(
                // fit: FlexFit.tight,
                sizes: 'col-12 col-sm-3 col-md-4 col-lg-4 col-xl-4',
                absoluteSizes: true,
                child: Card(
                  color: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        attribute.keys.first,
                        // textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        extractFeature(node).toString(),
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList()),
      ],
    );
  }
}
