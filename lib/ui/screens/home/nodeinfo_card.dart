import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/screens/home/save_card.dart';
import 'package:url_launcher/url_launcher.dart';

class NodeInfoCard extends StatelessWidget with GetItMixin {
  NodeInfoCard({super.key});
  @override
  Widget build(BuildContext context) {
    var nodeinfo = watchOnly((NodeManagerInfo nodeinfo) => nodeinfo.nodeinfo);
    //var tempchange = nodeinfo;

    return _MyDataTable(nodeinfo);
  }
}

class _MyDataTable extends StatefulWidget {
  final List<NodeInfo> nodeinfo; // Add this line to receive nodeinfo

  const _MyDataTable(this.nodeinfo); // Constructor to receive nodeinfo;
  @override
  _MyDataTableState createState() => _MyDataTableState(nodeinfo);
}

// Work below //
class _MyDataTableState extends State<_MyDataTable> {
  _MyDataTableState(this.nodeinfo);
  List<NodeInfo> nodeinfo;

  List<DataRow> allDataRows = [];
  List<DataRow> filteredRows = [];

  Map<String, double> columnWidths = {
    'Name': 100,
    'Provider': 100,
    'Price': 100,
    'IP Address': 100,
    'Txhash': 510,
    'Tier': 100,
    'Rank': 100,
    'Added Height': 100,
    'Confirmed Height': 100,
    '': 100,
  };

  int? _sortColumnIndex;
  bool _sortAscending = true;

  // contains attributes to be displayed in the table
  Map<String, String Function(NodeInfo)> attributes = {
    'Name': (node) => node.name ?? '',
    'Provider': (node) => node.provider ?? '',
    'Price': (node) => node.price.toString(),
    'IP Address': (node) => node.ip,
    'Txhash': (node) => node.txhash,
    'Tier': (node) => node.tier,
    'Rank': (node) => node.rank.toString(),
    'Added Height': (node) => node.added_height.toString(),
    'Confirmed Height': (node) => node.confirmed_height.toString(),
    '': (node) => ''
  };

  List<NodeInfo> filteredlist = [];

  @override
  void initState() {
    super.initState();
    filteredlist = List.from(nodeinfo);
    initNullFields();
    loadData();
  }

  void updateState() {
    // loadData();
    print('UPDATING STATE');
    setState(() {});
  }

  void loadData() {
    print('loading data');
    allDataRows = nodeinfo
        .map<DataRow>((node) => buildDataRow(context, node, attributes))
        .toList();
    filteredRows = List.from(allDataRows);
  }

  void modData() {}

  DataRow buildDataRow(context, node, attributes) {
    print('building data row');
    return DataRow(
      cells: attributes.entries.map<DataCell>((e) {
        var extractFeature = e.value;

        String featureValue = extractFeature(node);

        // general function to generate a data cell with colored text
        DataCell getTextDataCell(String text, Color color) {
          return DataCell(
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: columnWidths[e.key]!),
              child: Text(
                text,
                style: TextStyle(color: color),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
              ),
            ),
          );
        }

        // Save button
        if (e.key == '') {
          return DataCell(ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: columnWidths[e.key]!,
            ),
            child: SaveNodeButton(
              node,
              // update table with new values after edit
              reset: (() {
                updateState();
              }),
            ),
          ));
        }

        // ip hyperlink
        if (e.key == 'IP Address') {
          return DataCell(
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: columnWidths[e.key]!,
              ),
              child: InkWell(
                child: Text(
                  featureValue,
                  style: const TextStyle(color: Colors.lightBlue),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
                onTap: () async {
                  String port = featureValue.contains(':')
                      ? featureValue.split(':')[0]
                      : featureValue;
                  String url = 'http://$port:16126/';

                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
          );
        }

        // Color text red if the value is not set
        const keysToCheck = ['Name', 'Provider', 'Price'];
        if (keysToCheck.contains(e.key)) {
          if (featureValue == '-1') {
            featureValue = 'NOT SET';
          }

          Color textColor = (featureValue == 'NOT SET' || featureValue == '--')
              ? Colors.red
              : Colors.green;
          return getTextDataCell(featureValue, textColor);
        }

        // else case: return normal text
        return getTextDataCell(featureValue, Colors.green);
      }).toList(),
      onSelectChanged: (bool? selected) => displayPopout(node),
    );
  }

  double initX = 0;
  final minimumColumnWidth = 50.0;
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapCol(
          //  White space
          sizes: 'col-12 col-sm-6 col-md-9 col-lg-9 col-xl-9',
          //  White space
          child: const SizedBox(height: 50),
        ),
        BootstrapCol(
          // Search box
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
                      setState(() => filteredRows = allDataRows);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Search",
                    suffixIcon: Icon(Icons.search),
                  ),
                )),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: MediaQuery.of(context).size.width,
            height: 640,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: _buildDataTable(),
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.green, width: 4)),
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
      dividerThickness: 5,
      columnSpacing: 5,
      columns: attributes.entries
          .map((e) => DataColumn(
                label: Stack(
                  children: [
                    Container(
                      width: columnWidths[e.key],
                      constraints: const BoxConstraints(minWidth: 100),
                      child: Text(e.key),
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            initX = details.globalPosition.dx;
                          });
                        },
                        onPanUpdate: (details) {
                          final increment = details.globalPosition.dx - initX;
                          final newWidth = columnWidths[e.key]! + increment;
                          setState(() {
                            initX = details.globalPosition.dx;
                            columnWidths[e.key] = newWidth > minimumColumnWidth
                                ? newWidth
                                : minimumColumnWidth;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onSort: ((columnIndex, ascending) =>
                    _onSort(columnIndex, ascending)),
              ))
          .toList(),
      rows:
          // filteredRows,
          filteredlist.map<DataRow>((node) {
        return DataRow(
            onLongPress: () => displayPopout(node),
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
    if (e.key == '') {
      return DataCell(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: columnWidths[e.key]!,
          ),
          child: SaveNodeButton(
            node,
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
      maxLines: 1,
      softWrap: false,
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
        child: text,
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

  dynamic indexNodeMap(int index, NodeInfo node) {
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
        return node.txhash;
      case 5:
        return node.tier;
      case 6:
        return node.rank;
      case 7:
        return node.added_height;
      case 8:
        return node.confirmed_height;
    }
  }

  void _onSort(int columnIndex, bool ascending) {
    print('running onSort');
    setState(() {
      print('setting state in onSort');
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      // Sort the data based on the selected column and sorting direction
      filteredlist.sort((a, b) {
        final aValue = indexNodeMap(columnIndex, a);
        final bValue = indexNodeMap(columnIndex, b);

        // Make sure it doesn't sort numerically
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

  void filterData(String query) {
    print('FILTERING DATA');
    if (query.isEmpty) {
      setState(() => filteredlist = nodeinfo);
    } else {
      setState(() {
        // Filter based on search query
        filteredlist = nodeinfo.where((row) {
          String rowContent = row.txhash;
          // .map((cell) {
          //   return cell.child is Text
          //       ? (cell.child as Text).data!
          //       : cell.child is InkWell
          //           ? ((cell.child as InkWell).child as Text).data!
          //           : '';
          // }).join('***'); // should change this
          return rowContent.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void initNullFields() {
    nodeinfo.forEach((node) => {
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

  void displayPopout(node) {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopoutCard(node: node);
            // return Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(color: Colors.white, width: 4)),
            // );
          });
      // return true;
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
    // Map<String, String Function(NodeInfo)> attributes = {
    //   'IP Address': (node) => node.ip,
    //   'Txhash': (node) => node.txhash,
    //   'Tier': (node) => node.tier,
    //   'Rank': (node) => node.rank.toString(),
    //   'Added Height': (node) => node.added_height.toString(),
    //   'Confirmed Height': (node) => node.confirmed_height.toString(),
    //   'Last Confirmed Height': (node) => node.last_confirmed_height.toString(),
    //   'Outidx': (node) => node.outidx,
    //   'Network': (node) => node.network,
    //   'Last Paid Height': (node) => node.last_paid_height.toString(),
    //   'Payment Address': (node) => node.payment_address,
    //   // 'Pubkey': (node) => node.pubkey,
    //   'Active Since': (node) => node.activesince,
    //   'Last Paid': (node) => node.lastpaid,
    //   'Amount': (node) => node.amount,
    //   'Satoshis': (node) => node.satoshis.toString(),
    //   'Height': (node) => node.height.toString(),
    //   'Confirmations': (node) => node.confirmations.toString(),
    //   'Scriptpubkey': (node) => node.scriptPubKey,
    // };

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
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0), // Add margin here
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
