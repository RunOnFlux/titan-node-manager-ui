import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/save_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'package:testapp/ui/components/inline_edit.dart';
import 'package:testapp/ui/components/provider_dropdown.dart';

class NodeInfoCard extends StatelessWidget with GetItMixin {
  NodeInfoCard({super.key});
  @override
  Widget build(BuildContext context) {
    var nodeinfo = watchOnly((NodeManagerInfo nodeinfo) => nodeinfo.nodeinfo);
    var providers = watchOnly((NodeManagerInfo info) => info.info.providers);

    return _MyDataTable(nodeinfo, providers);
  }
}

class _MyDataTable extends StatefulWidget {
  final List<NodeInfo> nodeinfo;
  final List<String> providers;

  const _MyDataTable(this.nodeinfo, this.providers);
  @override
  _MyDataTableState createState() => _MyDataTableState(nodeinfo);
}

// Work below //
class _MyDataTableState extends State<_MyDataTable> {
  _MyDataTableState(this.nodeinfo);
  List<NodeInfo> nodeinfo;
  late List<String> providers;

  Map<String, double> columnWidths = {
    'Name': 100,
    'Provider': 100,
    'Price': 100,
    'IP Address': 110,
    'Txhash': 300,
    'Tier': 100,
    'Rank': 100,
    'Status': 80,
    'Address': 100,

    // 'Added Height': 100,
    // 'Confirmed Height': 100,
    '': 100,
  };

  int? _sortColumnIndex;
  bool _sortAscending = true;

  // contains attributes to be displayed in the table
  Map<String, String Function(NodeInfo)> attributes = {
    'Rank': (node) => node.rank.toString(),
    'Name': (node) => node.name ?? '',
    'Provider': (node) => node.provider ?? '',
    'Price': (node) => node.price.toString(),
    'IP Address': (node) => node.ip,
    'Txhash': (node) => node.txhash,
    'Tier': (node) => node.tier,
    'Address': (node) => node.payment_address,

    'Status': (node) => node.status,
    // 'Added Height': (node) => node.added_height.toString(),
    // 'Confirmed Height': (node) => node.confirmed_height.toString(),
    // '': (node) => ''
  };

  List<NodeInfo> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(nodeinfo);
    providers = widget.providers;
    uniformProviders();
    initNullFields();
  }

  void uniformProviders() {
    providers = providers.map((e) => e.toUpperCase()).toList().toSet().toList();
  }

  void updateState() {
    setState(() {});
  }

  double initX = 0;
  final minimumColumnWidth = 50.0;
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  void initNullFields() {
    nodeinfo.forEach((node) {
      node.name ??= 'NOT SET';
      node.name ??= 'NOT SET';
      node.provider ??= '--';
      node.price ??= -1;
    });
  }

  List<String> findAddresses() {
    List<String> addresses = [];
    for (var node in nodeinfo) {
      if (!addresses.contains(node.payment_address)) {
        addresses.add(node.payment_address);
      }
    }
    return addresses;
  }

  List<String> selectedAddresses = [];

  void selectAddress(String address) {
    if (selectedAddresses.contains(address)) {
      selectedAddresses.remove(address);
    } else {
      selectedAddresses.add(address);
    }
    setState(() {});
  }

  void filterDataByAddress() {
    if (selectedAddresses.isEmpty) {
      setState(() {
        filteredList = nodeinfo;
      });
      return;
    }
    setState(() {
      filteredList = nodeinfo.where((row) {
        return selectedAddresses.contains(row.payment_address);
      }).toList();
    });
  }

  ElevatedButton filterAddress(address) {
    bool selected = selectedAddresses.contains(address);
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(selected
            ? Colors.lightBlue
            : const Color.fromARGB(255, 8, 76, 132)),
      ),
      onPressed: () {
        selectAddress(address);
        filterDataByAddress();
      },
      child: Text(address),
    );
  }

  Widget filterAddresses() {
    List<String> addresses = findAddresses();
    List<Widget> addressButtons = [];

    for (var address in addresses) {
      addressButtons.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: filterAddress(address),
      ));
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: addressButtons,
        ));
  }

  BootstrapCol searchButton() {
    return BootstrapCol(
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
                  setState(() => filteredList = nodeinfo);
                }
              },
              decoration: const InputDecoration(
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapRow(
          children: [
            // shows how many selected addresses
            BootstrapCol(
              sizes: 'col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3',
              child: Text(
                'Selected Addresses: ${selectedAddresses.length}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        filterAddresses(),

        // searchButton(),

        // DATATABLE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.58,
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

  Widget _buildDataTable() {
    return DataTable(
      showCheckboxColumn: false,
      showBottomBorder: true,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      columnSpacing: 0,
      columns: attributes.entries.map((e) {
        return DataColumn(
          label: Stack(
            children: [
              Container(
                width: columnWidths[e.key],
                constraints: const BoxConstraints(minWidth: 100),
                child: Text(e.key),
              ),
              // Positioned(
              //   right: 0,
              //   child: GestureDetector(
              //     onPanStart: (details) {
              //       setState(() {
              //         initX = details.globalPosition.dx;
              //       });
              //     },
              //     onPanUpdate: (details) {
              //       final increment = details.globalPosition.dx - initX;
              //       final newWidth = columnWidths[e.key]! + increment;
              //       setState(() {
              //         initX = details.globalPosition.dx;
              //         columnWidths[e.key] = newWidth > minimumColumnWidth
              //             ? newWidth
              //             : minimumColumnWidth;
              //       });
              //     },
              //     child: Container(
              //       width: 10,
              //       height: 10,
              //       decoration: BoxDecoration(
              //         color: Colors.blue.withOpacity(1),
              //         shape: BoxShape.circle,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          onSort: ((columnIndex, ascending) => _onSort(columnIndex, ascending)),
        );
      }).toList(),
      rows: filteredList.map<DataRow>((node) {
        return DataRow(
            // onSelectChanged: (t) => displayPopout(node),
            cells: attributes.entries
                .map<DataCell>(
                  (e) => _buildCell(e, node),
                )
                .toList());
      }).toList(),
    );
  }

  DataCell _buildCell(
      MapEntry<String, String Function(NodeInfo)> e, NodeInfo node) {
    // Save node button
    if (e.key == '') {
      return DataCell(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: columnWidths[e.key]!,
          ),
          child: SaveNodeButton(
            node: node,
            reset: (() {
              updateState();
            }),
          ),
        ),
      );
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

    if (e.key == 'IP Address') {
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
          showSnackBarTop(context, 'IP address copied to clipboard');
        },

        child: text,
      );
    }

    if (e.key == 'Txhash') {
      text = InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: node.txhash));
          showSnackBarTop(context, 'Txhash copied to clipboard');
        },
        child: text,
      );
    }

    if (e.key == 'Name') {
      text = inlineEdit(node, value, updateState, 'Name');
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

  dynamic indexNodeMap(int index, NodeInfo node) {
    switch (index) {
      case 0:
        return node.rank;
      case 1:
        return node.name;
      case 2:
        return node.provider;
      case 3:
        return node.price;
      case 4:
        return node.ip;
      case 5:
        return node.txhash;
      case 6:
        return node.tier;
      case 7:
        return node.added_height;
      case 8:
        return node.confirmed_height;
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
      _sortColumnIndex = columnIndex; // Column to sort by
      _sortAscending = ascending; // Which direction to sort
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

  List<dynamic> getRowData(NodeInfo node) {
    return [
      node.rank.toString(),
      node.name,
      node.provider,
      node.price.toString(),
      node.ip.toString(),
      node.txhash,
      node.tier,
    ];
  }

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() => filteredList = nodeinfo);
    } else {
      setState(() {
        // Filter based on search query
        filteredList = nodeinfo.where((row) {
          String rowContent = "";
          getRowData(row).forEach((cell) {
            rowContent += cell.toString();
          });
          return rowContent.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void displayPopout(node) {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopoutCard(node: node);
          });
    } catch (err) {
      rethrow;
    }
  }
}

// displays more info when the node row is clicked.
class PopoutCard extends StatelessWidget {
  final dynamic node;

  PopoutCard({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
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
      {'Last Paid Height': (node) => node.last_paid_height.toString()},
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

    // Shows extra info about the node if you click on the node row
    return BootstrapContainer(
      padding: const EdgeInsets.all(100.0),
      fluid: true,
      children: [
        BootstrapRow(
            children: attributes.map((attribute) {
          var extractFeature = attribute.values.first;
          return BootstrapCol(
            sizes: 'col-12 col-sm-3 col-md-4 col-lg-4 col-xl-4',
            absoluteSizes: false,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                color: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListTile(
                    title: Text(
                      attribute.keys.first,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      extractFeature(node).toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[900],
                      ),
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
