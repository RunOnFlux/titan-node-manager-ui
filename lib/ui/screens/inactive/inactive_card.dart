import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/config.dart';

import 'package:http/http.dart' as http;
import 'package:testapp/ui/components/save_card.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:testapp/ui/components/inline_edit.dart';
import 'package:testapp/ui/components/provider_dropdown.dart';
import 'package:testapp/ui/screens/login/login_card.dart';

class InactiveCard extends StatelessWidget with GetItMixin {
  InactiveCard({super.key});
  @override
  Widget build(BuildContext context) {
    var inactiveInfo =
        watchOnly((NodeManagerInfo inactiveInfo) => inactiveInfo.inactiveInfo);
    var providers = watchOnly((NodeManagerInfo info) => info.info.providers);

    return _MyDataTable(inactiveInfo, providers);
  }
}

class _MyDataTable extends StatefulWidget {
  final List<InactiveInfo> inactiveInfo;
  final List<String> providers;

  const _MyDataTable(this.inactiveInfo, this.providers);
  @override
  _MyDataTableState createState() => _MyDataTableState(inactiveInfo);
}

// Work below //
class _MyDataTableState extends State<_MyDataTable> {
  _MyDataTableState(this.inactiveInfo);
  List<InactiveInfo> inactiveInfo;
  late List<String> providers;

  Map<String, double> columnWidths = {
    'Name': 80,
    'Provider': 80,
    'Price': 80,
    'IP Address': 110,
    'Txhash': 300,
    'Tier': 80,
    'Status': 80,
    'Amount': 80,
    '': 50,
    'Save': 50
  };

  // Holds key for each row that is selected
  Map<String, InactiveInfo> selectedRows = {};
  DataTable? dataTable;
  bool showButton = false; // Start selected nodes button

  int? _sortColumnIndex;
  bool _sortAscending = true;

  // contains attributes to be displayed in the table
  Map<String, String Function(InactiveInfo)> attributes = {
    'Name': (node) => node.name ?? '',
    'Provider': (node) => node.provider ?? '',
    'Price': (node) => node.price.toString(),
    'IP Address': (node) => node.ip,
    'Txhash': (node) => node.txid,
    'Tier': (node) => node.tier,
    'Status': (node) => node.status,
    'Amount': (node) => node.amount.toString(),
    '': (node) => '',
    // 'Save': (node) => '',
  };

  List<InactiveInfo> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(inactiveInfo);
    providers = widget.providers;
    initNullFields();
  }

  void updateState() {
    setState(() {});
  }

  double initX = 0;
  final minimumColumnWidth = 10;
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  void initNullFields() {
    inactiveInfo.forEach((node) => {
          if (node.name == null)
            {
              node.name = 'NOT SET',
            },
          if (node.provider == null)
            {
              node.provider = '--',
            },
          if (node.price == null)
            {
              node.price = -1,
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapCol(
          //  White space
          sizes: 'col-12 col-sm-6 col-md-9 col-lg-9 col-xl-9',
          child: SizedBox(
            width: 200,
            height: 50,
            child: Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: showButton,
              child: StartSelectedNodes(selectedRows.values.toList()),
            ),
          ),
        ),
        BootstrapCol(
          // SEARCH BOX
          sizes: 'col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3',
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
                width: 200,
                height: 50,
                child: TextField(
                  onSubmitted: filterData,
                  onChanged: (query) {
                    if (query.isEmpty) {
                      setState(() => filteredList = inactiveInfo);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Search",
                    suffixIcon: Icon(Icons.search),
                  ),
                )),
          ),
        ),
        // DATATABLE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.60,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.60,
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical, child: _buildDataTable()),
          ),
        ),
      ],
    );
  }

  Map<String, Color> rowColors = {};
  Color scaffoldBackgroundDark = const Color.fromARGB(255, 20, 22, 41);
  Color cardColorDark = const Color.fromARGB(255, 58, 58, 78);

  Widget _buildDataTable() {
    return DataTable(
      showCheckboxColumn: false,
      showBottomBorder: true,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      columnSpacing: 0,
      dividerThickness: 0,
      columns: attributes.entries.map((e) {
        String title = e.key == 'Save' ? '' : e.key;
        return DataColumn(
          label: Stack(
            children: [
              Container(
                width: columnWidths[e.key],
                constraints: const BoxConstraints(minWidth: 10),
                child: Text(title),
              ),
            ],
          ),
          onSort: ((columnIndex, ascending) => _onSort(columnIndex, ascending)),
        );
      }).toList(),
      rows: filteredList.map<DataRow>((node) {
        return DataRow(
          color: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return rowColors[node.txid] ?? scaffoldBackgroundDark;
          }),
          // onSelectChanged: (t) => displayPopout(node),
          cells: attributes.entries
              .map<DataCell>(
                (e) => _buildCell(e, node),
              )
              .toList(),
          onSelectChanged: (bool? selected) {
            String myKey = node.txid;
            if (selected != null) {
              selected = selectedContains(node);
              setState(() {
                if (selected == false) {
                  rowColors[myKey] = cardColorDark;
                  selectedRows[myKey] = node;
                  if (selectedRows.length > 1) {
                    showButton = true;
                  }
                } else {
                  rowColors[myKey] = scaffoldBackgroundDark;
                  selectedRows.remove(myKey);
                  if (selectedRows.length <= 1) {
                    showButton = false;
                  }
                }
              });
            }
          },
        );
      }).toList(),
    );
  }

  bool selectedContains(node) {
    String myKey = node.txid;
    bool contain = selectedRows.containsKey(myKey);
    return contain;
  }

  DataCell _buildCell(
      MapEntry<String, String Function(InactiveInfo)> e, InactiveInfo node) {
    // Save node button
    if (e.key == 'Save') {
      return DataCell(
        SaveNodeButton(
          node: node,
          reset: (() {
            updateState();
          }),
        ),
      );
    }

    if (e.key == '') {
      var startCell = DataCell(StartNodeButton(node));
      return startCell;
    }

    String value = e.value(node);

    const keysToCheck = ['Name', 'Provider', 'Price'];
    if (keysToCheck.contains(e.key)) {
      if (value == '-1') {
        value = 'NOT SET';
      }
    }
    Color textColor = (value == 'NOT SET' || value == '--')
        ? Colors.red
        : (e.key == 'IP Address')
            ? Colors.lightBlue
            : Colors.green;
    Widget text = Text(
      value,
      style: TextStyle(color: textColor),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      softWrap: true,
    );

    if (e.key == 'IP Address' && value != 'Unknown') {
      text = InkWell(
        onTap: () async {
          String port = value.contains(':') ? value.split(':')[0] : value;
          String url = 'http://$port:16126/';

          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch $url';
          }
        },
        // On long press save the ip to clipboard
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: value));
          showSnackBarTop(context, 'IP Address copied to clipboard');
        },
        child: text,
      );
    }

    if (e.key == 'Txhash') {
      text = InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: node.txid));
          showSnackBarTop(context, 'Txhash copied to clipboard');
        },
        child: text,
      );
    }

    if (e.key == 'Name') {
      text = inlineEdit(node, value, updateState, "Name");
    }

    if (e.key == 'Price') {
      text = inlineEdit(node, value, updateState, "Price");
    }

    if (e.key == 'Provider') {
      text = ProviderDropdown(
        node: node,
        providers: providers,
        selectedProvider: value,
        onProviderSelected: (String provider) {
          node.provider = provider;
          updateState();
        },
      );
    }

    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: columnWidths[e.key]!,
        ),
        child: text,
      ),
    );
  }

  InlineTextEdit inlineEdit(node, text, reset, property) {
    TextEditingController _editingController =
        TextEditingController(text: text);

    InlineTextEdit inline = InlineTextEdit(
      node: node,
      controller: _editingController,
      reset: reset,
      property: property,
    );
    return inline;
  }

  dynamic indexNodeMap(int index, InactiveInfo node) {
    switch (index) {
      case 0:
        return node.name;
      case 1:
        return node.provider;
      case 2:
        return node.price;
      case 3:
        return node.ip;
      case 4:
        return node.txid;
      case 5:
        return node.tier;
    }
  }

  showSnackBarTop(context, message) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 12, 0, 150)),
      ),
      backgroundColor: Color.fromARGB(255, 204, 204, 204),
      dismissDirection: DismissDirection.up,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.9,
          left: 10,
          right: 10),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      // Sort the data based on the selected column and sorting direction
      filteredList.sort((a, b) {
        final aValue = indexNodeMap(columnIndex, a);
        final bValue = indexNodeMap(columnIndex, b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  List<dynamic> getRowData(node) {
    return [
      node.name,
      node.provider,
      node.price.toString(),
      node.ip.toString(),
      node.txid,
      node.tier,
      node.status,
      node.amount,
    ];
  }

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() => filteredList = inactiveInfo);
    } else {
      setState(() {
        // Filter based on search query
        filteredList = inactiveInfo.where((row) {
          String rowContent = "";
          getRowData(row).forEach((cell) {
            rowContent += cell.toString();
          });
          return rowContent.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }
}

class StartNodeButton extends StatelessWidget {
  final InactiveInfo node;

  const StartNodeButton(this.node, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Start'),
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

class StartSelectedNodes extends StatelessWidget {
  final List<InactiveInfo> nodes;

  StartSelectedNodes(this.nodes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullResponse = '';

    return ElevatedButton(
      child: const Text('Start Selected Nodes'),
      onPressed: () {
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
          fullResponse = ''; // Reset after clicking button
        });
      },
    );
  }
}

Future<http.Response> startNode(BuildContext context, node) async {
  var txhash = node.txid;
  var outidx = node.vout;
  final String? token = await storage.read(key: "jwt");

  Map<String, dynamic> requestBody = {
    'txhash': txhash,
    'outidx': outidx,
  };
  var url = Uri.parse('${AppConfig().apiEndpoint}/startnode');

  final response = await http.post(
    url,
    body: jsonEncode(requestBody),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    },
  );

  return response;
}
