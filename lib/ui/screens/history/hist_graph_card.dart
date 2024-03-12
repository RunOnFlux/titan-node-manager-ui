import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/generic_card.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:testapp/api/model/history.dart';

class HistGraph extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    final History history =
        watchOnly((NodeManagerInfo nodeManagerInfo) => nodeManagerInfo.history);

    final unsortedData = sumData(history.nodeActivity);
    // sort the data map in alphabetical order
    final data = Map.fromEntries(unsortedData.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    // return Container(child: Text('Drops by Month (Placeholder Data)'));

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          // make the graph size dependent on the screen size
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.30,
          // the child is a bar graph
          child: Column(
            children: [
              Text('Drops by Month (Placeholder Data)',
                  style: TextStyle(fontSize: 20)),
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white, width: 1),
                    ),

                    minY: 0,
                    maxY: 10,
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('Jan');
                              case 1:
                                return Text('Feb');
                              case 2:
                                return Text('Mar');
                              case 3:
                                return Text('Apr');
                              case 4:
                                return Text('May');
                              case 5:
                                return Text('Jun');
                              case 6:
                                return Text('Jul');
                              case 7:
                                return Text('Aug');
                              case 8:
                                return Text('Sep');
                              case 9:
                                return Text('Oct');
                              case 10:
                                return Text('Nov');
                              case 11:
                                return Text('Dec');
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 30,
                          interval: 5,
                          showTitles:
                              true, // Adjust based on whether you want to show left axis titles
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                    ),
                    barGroups: makeGroups(data),
                    // Additional BarChartData configurations...
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 2,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey,
                          strokeWidth: 0.5,
                        );
                      },
                    ),
                    alignment: BarChartAlignment.spaceAround,

                    groupsSpace: 15,
                  ),
                ),
              ),
              buildLegend(data),
            ],
          ),
        ),
      ),
    );
  }

  //   final List<Map<String, dynamic>> data = [
  //   {
  //     'name': 'Hetzner',
  //     'color': Colors.red,
  //     'drops': {0: 2, 1: 4, 2: 3}
  //   },
  //   {
  //     'name': 'Hostnodes',
  //     'color': Colors.green,
  //     'drops': {0: 3, 1: 2, 2: 1}
  //   },
  //   {
  //     'name': 'Jriggs',
  //     'color': Colors.blue,
  //     'drops': {0: 1, 1: 2, 2: 3}
  //   },
  //   {
  //     'name': 'Terra Hosting',
  //     'color': Colors.yellow,
  //     'drops': {0: 0, 1: 1, 2: 1}
  //   },
  //   {
  //     'name': 'wrench',
  //     'color': Colors.purple,
  //     'drops': {0: 3, 1: 1, 2: 2}
  //   },
  //   {
  //     'name': 'OVH',
  //     'color': Colors.orange,
  //     'drops': {0: 2, 1: 3, 2: 0}
  //   },
  //   {
  //     'name': 'Other',
  //     'color': Colors.grey,
  //     'drops': {0: 1, 1: 2, 2: 5}
  //   }
  // ];

  List<dynamic> monthInterval() {
    var now = DateTime.now();
    var month = now.month;
    var year = now.year;
    var interval = [];
    for (var i = 0; i < 3; i++) {
      if (month == 0) {
        month = 11;
        year--;
      } else {
        month--;
      }
      interval.add(month);
    }
    // return the interval in reverse order
    return interval.reversed.toList();
  }

  Map<String, dynamic> sumData(nodeActivity) {
    Map<String, dynamic> data = {};

    Color findColor(provider) {
      switch (provider) {
        case 'hetzner':
          return Colors.red;
        case 'hostnodes':
          return Colors.green;
        case 'jriggs':
          return Colors.blue;
        case 'terra hosting':
          return Colors.yellow;
        case 'wrench':
          return Colors.purple;
        case 'ovh':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    for (var i = 0; i < nodeActivity.length; i++) {
      var event = nodeActivity[i];
      var provider = event.provider.toLowerCase();
      var timestamp = event.timestamp;
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      // adjust month to be 0-indexed
      var month = date.month - 1;

      // var year = date.year;

      if (data[provider] == null) {
        data[provider] = {
          'provider': provider,
          'drops': {
            0: 0, // Jan
            1: 0, // Feb
            2: 0, // etc.
            3: 0,
            4: 0,
            5: 0,
            6: 0,
            7: 0,
            8: 0,
            9: 0,
            10: 0,
            11: 0
          },
          'color': findColor(provider),
        };
      }
      data[provider]['drops'][month]++;
    }
    return data;
  }

  List<BarChartGroupData> makeGroups(data) {
    // function that returns an interval which represents the last 3 months

    final providers = data.values.toList();
    final lastThreemonths = monthInterval(); // ex. [4,5,6]
    List<BarChartGroupData> groups = [];
    // iterate through the last 3 months and create a group for each month
    for (var monthIndex = 0; monthIndex < 3; monthIndex++) {
      List<BarChartRodData> bars = [];
      // iterate through the providers and create a bar for each provider
      for (var provIndex = 0; provIndex < providers.length; provIndex++) {
        bars.add(BarChartRodData(
          toY: providers[provIndex]['drops'][lastThreemonths[monthIndex]]
              .toDouble(),
          color: providers[provIndex]['color'],
          width: 13,
        ));
      }
      groups.add(BarChartGroupData(
        x: lastThreemonths[monthIndex],
        barRods: bars,
      ));
    }
    return groups;
  }

  Widget buildLegend(Map<String, dynamic> data) {
    return Row(
      children: data.values.map((value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: value['color'],
              ),
              SizedBox(width: 8),
              Text(value['provider'], style: TextStyle(fontSize: 10)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class HistGraphCard extends StatelessWidget with GetItMixin {
  HistGraphCard({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapRow(
            height: MediaQuery.of(context).size.height * 0.35,
            children: [
              BootstrapCol(
                fit: FlexFit.tight,
                sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.red, width: 2),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      // make the graph size dependent on the screen size
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: HistGraph(),
                    ),
                  ),
                ),
              ),
            ]),
        BootstrapRow(
            height: MediaQuery.of(context).size.height * 0.35,
            children: [
              BootstrapCol(
                fit: FlexFit.tight,
                sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      // make the graph size dependent on the screen size
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: Text('Similar but with cost instead of drops'),
                    ),
                  ),
                ),
              ),
            ]),
      ],
    );
  }
}
