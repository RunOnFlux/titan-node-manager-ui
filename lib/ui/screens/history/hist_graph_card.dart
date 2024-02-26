import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/generic_card.dart';
import 'package:fl_chart/fl_chart.dart';

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
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                  ),
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

class HistGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.red, width: 2),
      // ),
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
                    minY: 0,
                    maxY: 6,
                    titlesData: FlTitlesData(
                      show: true,
                      // make it so i dont see the top titles
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
                              // Continue for other months as needed
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
                          interval: 1,
                          showTitles:
                              true, // Adjust based on whether you want to show left axis titles
                        ),
                      ),
                    ),
                    barGroups: makeGroups(),
                    // Additional BarChartData configurations...
                    gridData: FlGridData(
                      show: true,
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

  List<BarChartGroupData> makeGroups() {
    List<BarChartGroupData> groups = [];
    for (var i = 0; i < 3; i++) {
      List<BarChartRodData> bars = [];
      for (var j = 0; j < data.length; j++) {
        bars.add(BarChartRodData(
          toY: data[j]['drops'][i].toDouble(),
          color: data[j]['color'],
          width: 13,
        ));
      }
      groups.add(BarChartGroupData(
        x: i,
        barRods: bars,
      ));
    }
    return groups;
  }

  final List<Map<String, dynamic>> data = [
    {
      'name': 'Hetzner',
      'color': Colors.red,
      'drops': {0: 2, 1: 4, 2: 3}
    },
    {
      'name': 'Hostnodes',
      'color': Colors.green,
      'drops': {0: 3, 1: 2, 2: 1}
    },
    {
      'name': 'Jriggs',
      'color': Colors.blue,
      'drops': {0: 1, 1: 2, 2: 3}
    },
    {
      'name': 'Terra Hosting',
      'color': Colors.yellow,
      'drops': {0: 0, 1: 1, 2: 1}
    },
    {
      'name': 'wrench',
      'color': Colors.purple,
      'drops': {0: 3, 1: 1, 2: 2}
    },
    {
      'name': 'OVH',
      'color': Colors.orange,
      'drops': {0: 2, 1: 3, 2: 0}
    },
    {
      'name': 'Other',
      'color': Colors.grey,
      'drops': {0: 1, 1: 2, 2: 5}
    }
  ];

  Widget buildLegend(List<Map<String, dynamic>> data) {
    return Row(
      children: data.map((data) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: data['color'],
              ),
              SizedBox(width: 8),
              Text(data['name'], style: TextStyle(fontSize: 10)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
