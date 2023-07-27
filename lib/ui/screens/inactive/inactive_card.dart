import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
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
      child: _MyDataTable(inactiveInfo),
    );
  }
}

class _MyDataTable extends StatefulWidget {
  final List<InactiveInfo> nodeinfo; // Add this line to receive nodeinfo

  _MyDataTable(this.nodeinfo); // Constructor to receive nodeinfo;
  @override
  _MyDataTableState createState() => _MyDataTableState(nodeinfo);
}

class _MyDataTableState extends State<_MyDataTable> {
  _MyDataTableState(this.nodeinfo);
  List<InactiveInfo> nodeinfo;

  List<DataRow> allDataRows = [];
  List<DataRow> filteredRows = [];

  int? _sortColumnIndex;
  bool _sortAscending = true;

  List<Map<String, dynamic Function(dynamic)>> attributes = [
    {'': (node) => ''},
    {'Txhash': (node) => node.txid},
    {'Amount': (node) => node.amount.toString()},
    {'Satoshis': (node) => node.satoshis.toString()},
    {'Height': (node) => node.height.toString()},
    {'Confirmations': (node) => node.confirmations.toString()},
  ];

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
        columns: attributes.map((attribute) {
          // Headerless column
          if (attribute.keys.first == '') {
            return DataColumn2(label: Text(''));
          } else {
            return DataColumn2(
              label: Text(attribute.keys.first),
              onSort: (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending),
            );
          }
        }).toList(),
        rows: filteredRows);
  }

  DataRow buildDataRow(node, attributes) {
    var startCell = DataCell(StartNodeButton(node));
    List<DataCell> cells = attributes.map<DataCell>((attribute) {
      // Headerless column contains startnode button
      if (attribute.keys.first == '') {
        return startCell;
      } else {
        return DataCell(
          Text(attribute.values.first(node),
              style: const TextStyle(color: Colors.red)),
        );
      }
    }).toList();

    return DataRow(cells: cells);
  }
}

class StartNodeButton extends StatelessWidget {
  final dynamic node;

  StartNodeButton(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Start Fluxnode'),
      // Tries startNode and send the api's response as popup message
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FutureBuilder<http.Response>(
              future: startNode(context, node),
              builder: (context, snapshot) {
                // the following 3 cases associate with the FutureBuilder's
                // connectionState can which may return 3 states: waiting, error, success
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AlertDialog(
                    content: Text('Loading...'),
                  );
                } else if (snapshot.hasError) {
                  // probably should build out error catching system
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Failed to start Fluxnode.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // dismisses popup
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                } else {
                  String responseString = snapshot.data!.body;
                  return AlertDialog(
                    content: Text(responseString),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // dismisses popup
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}

Future<http.Response> startNode(BuildContext context, node) async {
  var txhash = node.txid;
  var outidx = node.vout;

  Map<String, dynamic> requestBody = {
    'txhash': txhash,
    'outidx': outidx,
  };
  // print('startNode: \n txhash-->${txhash} \n body-->$requestBody');
  var url = Uri.parse('http://localhost:4444/api/startnode');

  final response = await http.post(
    url,
    body: jsonEncode(requestBody),
    headers: {'Content-Type': 'application/json'},
  );
  return response;
}
