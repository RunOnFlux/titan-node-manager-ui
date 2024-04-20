import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/generic_card.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:testapp/api/model/history.dart';

class DropsByMonth extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    final History history =
        watchOnly((NodeManagerInfo nodeManagerInfo) => nodeManagerInfo.history);

    final unsortedData = sumData(history.nodeActivity);
    // sort the data map in alphabetical order
    final data = Map.fromEntries(unsortedData.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

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
              Text('Drops by Month', style: TextStyle(fontSize: 20)),
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
                          interval: 2,
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
        var drops = providers[provIndex]['drops'][lastThreemonths[monthIndex]];
        // Do not create a bar in the graph if there are no drops
        if (drops == 0) {
          continue;
        }
        if (drops > 10) {
          drops = 10;
        }
        bars.add(BarChartRodData(
          toY: drops.toDouble(),
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
    // create the same legend but with a for loop instead

    return Row(
      children: data.values.map((value) {
        if (value['color'] == Colors.grey) {
          if (value['provider'] == '--') {
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
                  Text('Other', style: TextStyle(fontSize: 10)),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
        ;
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

class DailyLoss extends StatelessWidget with GetItMixin {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<DateTime> lastTenDays() {
    var now = DateTime.now();
    List<DateTime> days = [];
    for (int i = 0; i < 10; i++) {
      // Subtract `i` days from today's date and add to the list
      days.add(now.subtract(Duration(days: i)));
    }

    // change the formatting of days to just be mm-dd-yyyy
    days = days.map((day) {
      return DateTime(day.year, day.month, day.day);
    }).toList();
    // Return the list in reverse order to start from 10 days ago to today

    return days.reversed.toList();
  }

  Map<String, double> lineChartData(lastTenDays, dailyLoss) {
    final Map<String, double> data = {};
    for (var i = 0; i < lastTenDays.length; i++) {
      var date = lastTenDays[i];
      var formattedDate = '${date.month}/${date.day}/${date.year}';

      if (dailyLoss[formattedDate] == null) {
        data[formattedDate] = 0;
        continue;
      }
      data[formattedDate] = dailyLoss[formattedDate][0] ?? 0;
    }
    return data;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var dayInterval = lastTenDays();
    var dayIntervalString = dayInterval.map((day) {
      return '${day.month}/${day.day}';
    }).toList();
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(dayIntervalString[0], style: style);
        break;
      case 1:
        text = Text(dayIntervalString[1], style: style);
        break;
      case 2:
        text = Text(dayIntervalString[2], style: style);
        break;
      case 3:
        text = Text(dayIntervalString[3], style: style);
        break;
      case 4:
        text = Text(dayIntervalString[4], style: style);
        break;
      case 5:
        text = Text(dayIntervalString[5], style: style);
        break;
      case 6:
        text = Text(dayIntervalString[6], style: style);
        break;
      case 7:
        text = Text(dayIntervalString[7], style: style);
        break;
      case 8:
        text = Text(dayIntervalString[8], style: style);
        break;
      case 9:
        text = Text(dayIntervalString[9], style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(data) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, data.values.elementAt(0)),
            FlSpot(1, data.values.elementAt(1)),
            FlSpot(2, data.values.elementAt(2)),
            FlSpot(3, data.values.elementAt(3)),
            FlSpot(4, data.values.elementAt(4)),
            FlSpot(5, data.values.elementAt(5)),
            FlSpot(6, data.values.elementAt(6)),
            FlSpot(7, data.values.elementAt(7)),
            FlSpot(8, data.values.elementAt(8)),
            FlSpot(9, data.values.elementAt(9)),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final History history =
        watchOnly((NodeManagerInfo nodeManagerInfo) => nodeManagerInfo.history);

    final dailyLoss = history.dailyLoss;
    final daysInterval = lastTenDays();
    final data = lineChartData(daysInterval, dailyLoss);
    print('data: $data');

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
              Text('Daily Loss In The Last 10 Days',
                  style: TextStyle(fontSize: 20)),
              Expanded(
                child: LineChart(mainData(data)),
              ),
            ],
          ),
        ),
      ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      // make the graph size dependent on the screen size
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: DropsByMonth(),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      // make the graph size dependent on the screen size
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: DailyLoss(),
                    ),
                  ),
                ),
              ),
            ]),
      ],
    );
  }
}
