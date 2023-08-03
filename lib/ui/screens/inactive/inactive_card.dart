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
  Map<String, InactiveInfo> selectedRows =
      {}; // Holds txhash:outidx for each row
  DataTable? dataTable;
  bool showButton = false;

  int? _sortColumnIndex;
  bool _sortAscending = true;

  Color primaryColorDark = const Color.fromARGB(255, 38, 86, 198);
  Color darkText = const Color.fromARGB(255, 208, 210, 214);
  Color scaffoldBackgroundDark = const Color.fromARGB(255, 20, 22, 41);
  Color cardColorDark = Color.fromARGB(255, 58, 58, 78);
  Color rowColor = const Color.fromARGB(255, 14, 16, 33);

  List<Map<String, dynamic Function(dynamic)>> attributes = [
    {'Txhash': (node) => node.txid},
    {'Amount': (node) => node.amount.toString()},
    {'Vout': (node) => node.vout.toString()},

    // {'Satoshis': (node) => node.satoshis.toString()},
    // {'Height': (node) => node.height.toString()},
    // {'Confirmations': (node) => node.confirmations.toString()},
    {'': (node) => ''},
  ];

  @override
  void initState() {
    super.initState();
    loadData();
    showButton = false;
    rowColor = scaffoldBackgroundDark;
  }

  void loadData() {
    allDataRows = nodeinfo
        .map<DataRow>((node) => buildDataRow(node, attributes))
        .toList();
    filteredRows = List.from(allDataRows);
  }

  @override
  Widget build(BuildContext context) {
    allDataRows =
        nodeinfo.map((node) => buildDataRow(node, attributes)).toList();
    return BootstrapContainer(children: [
      Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: showButton,
        child: StartSelectedNodes(selectedRows.values.toList()),
      ),
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
        // border: TableBorder.all(color: Colors.white),
        showCheckboxColumn: false,
        // columnSpacing: 12,
        horizontalMargin: 12,
        smRatio: .5,
        lmRatio: 2,
        minWidth: 600,
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: attributes.map((attribute) {
          // Headerless column
          if (attribute.keys.first == '') {
            return DataColumn2(size: ColumnSize.M, label: Text(''));
          } else {
            if (attribute.keys.first == 'Txhash') {
              return DataColumn2(
                size: ColumnSize.L,
                label: Text(attribute.keys.first),
                onSort: (columnIndex, ascending) =>
                    _onSort(columnIndex, ascending),
              );
            }
            return DataColumn2(
              size: ColumnSize.S,
              label: Text(attribute.keys.first),
              onSort: (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending),
            );
          }
        }).toList(),
        rows: filteredRows);
  }

  bool selectedContains(node) {
    String myKey = node.txid;
    bool contain = selectedRows.containsKey(myKey);
    return contain;
  }

  Map<String, Color> rowColors = {};

  DataRow buildDataRow(node, attributes) {
    // print('building data row');
    var startCell = DataCell(StartNodeButton(node));
    List<DataCell> cells = attributes.map<DataCell>((attribute) {
      // Headerless column contains startnode button
      if (attribute.keys.first == '') {
        return startCell;
      } else {
        if (attribute.keys.first == 'Txhash') {}
        return DataCell(
          Text(attribute.values.first(node),
              style: const TextStyle(color: Colors.red)),
        );
      }
    }).toList();

    return DataRow(
      color:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        return rowColors[node.txid] ?? scaffoldBackgroundDark;
      }),
      cells: cells,
      selected: true,
      onSelectChanged: (bool? selected) {
        String myKey = node.txid;
        if (selected != null) {
          selected = selectedContains(node);
          setState(() {
            if (selected == false) {
              rowColors[myKey] = cardColorDark;
              selectedRows[myKey] = node;
              print('Selectedrows Size: ${selectedRows.length}');
              print('Node added');
              if (selectedRows.length > 1) {
                showButton = true;
              }
            } else {
              rowColors[myKey] = scaffoldBackgroundDark;
              selectedRows.remove(myKey);
              if (selectedRows.length <= 1) {
                print('removing selected rows button');
                showButton = false;
              }
              print('Node removed');
            }
          });
        }
      },
    );
  }
}

class StartNodeButton extends StatelessWidget {
  final InactiveInfo node;

  const StartNodeButton(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Start Fluxnode'),
      // Attempts startNode and send the api's response as popup message
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
  var url = Uri.parse('http://localhost:4444/api/startnode');

  final response = await http.post(
    url,
    body: jsonEncode(requestBody),
    headers: {'Content-Type': 'application/json'},
  );
  return response;
}

class StartSelectedNodes extends StatelessWidget {
  final List<InactiveInfo> nodes;
  List<FutureBuilder<http.Response>> responseList = [];
  String fullResponse = '';

  StartSelectedNodes(this.nodes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('displaying start selected nodes button');
    return ElevatedButton(
      child: const Text('Start Selected Nodes'),
      onPressed: () {
        print('button pressed');
        List<Future<http.Response>> nodeFutures = nodes.map((node) {
          return startNode(context, node);
        }).toList();

        Future.wait(nodeFutures).then((responses) async {
          for (var response in responses) {
            fullResponse += '${response.body}\n';
          }
          fullResponse = fullResponse.substring(
              0, fullResponse.length - 1); // erases newline at the end
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                content: Text(fullResponse),
              );
            },
          );
          fullResponse = '';
        });
      },
    );
  }
}
