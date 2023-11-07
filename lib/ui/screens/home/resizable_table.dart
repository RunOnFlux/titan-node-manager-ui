import 'package:flutter/material.dart';

class TableColumnResize extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TableColumnResize();
}

class _TableColumnResize extends State<TableColumnResize> {
  double columnWidth = 200;
  Map<String, double> colWidths = {
    'Column 1': 200,
    'Column yeet': 200,
  };
  double initX = 0;
  final minimumColumnWidth = 50.0;
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table Column Resize"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
          ),
          margin: const EdgeInsets.all(15.0),

          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true, // make the scrollbar easy to see
            controller: verticalScrollController,
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              controller: horizontalScrollController,
              notificationPredicate: (notif) => notif.depth == 1,
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: _resizableColumnWidth(),
                ),
              ),
            ),
          ),

          // child: InteractiveViewer(
          //   child: _resizableColumnWidth(),
          //   constrained: false,
          //   scaleEnabled: false,
          // ),
        ),
      ),
    );
  }

  Widget _resizableColumnWidth() {
    return DataTable(
        dividerThickness: 5,
        columns: [
          DataColumn(
            label: Stack(
              children: [
                Container(
                  child: Text('Column 1'),
                  width: colWidths['Column 1']!,
                  constraints: BoxConstraints(minWidth: 100),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onPanStart: (details) {
                      // debugPrint(details.globalPosition.dx.toString());
                      setState(() {
                        initX = details.globalPosition.dx;
                      });
                    },
                    onPanUpdate: (details) {
                      final increment = details.globalPosition.dx - initX;
                      // debugPrint(newWidth.toString());
                      final newWidth = colWidths['Column 1']! + increment;
                      setState(() {
                        initX = details.globalPosition.dx;
                        colWidths['Column 1'] = newWidth > minimumColumnWidth
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
          ),
          DataColumn(
            label: Stack(
              children: [
                Container(
                  child: Text('Column yeet'),
                  width: colWidths['Column yeet']!,
                  constraints: BoxConstraints(minWidth: 100),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onPanStart: (details) {
                      // debugPrint(details.globalPosition.dx.toString());
                      setState(() {
                        initX = details.globalPosition.dx;
                      });
                    },
                    onPanUpdate: (details) {
                      final increment = details.globalPosition.dx - initX;
                      // debugPrint(newWidth.toString());
                      final newWidth = colWidths['Column yeet']! + increment;
                      setState(() {
                        initX = details.globalPosition.dx;
                        colWidths['Column yeet'] = newWidth > minimumColumnWidth
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
          ),
          DataColumn(label: Text("Column 3")),
        ],
        rows: List.generate(20, (index) {
          return DataRow(
            cells: [
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: colWidths['Column 1']!),
                  // constraints: BoxConstraints(maxWidth: colWidths['Column 1']!),

                  child: Text(
                    "Column1: Row index $index: long text 1234567890 1234567890 1234567890 1234567890",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ),
              DataCell(Text("Column2: Row index $index")),
              DataCell(Text("Column3: Row index $index")),
            ],
          );
        }));
  }
}
