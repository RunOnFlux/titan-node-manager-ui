import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/generic_card.dart';

class HistInfoCard extends StatelessWidget with GetItMixin {
  HistInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var history =
        watchOnly((NodeManagerInfo nodeManagerInfo) => nodeManagerInfo.history);

    var infoMap = {
      'Daily Earn': '0',
      'Weekly Cost': 'Not implemented',
      'Monthly Cost': '0',
      'Payouts Received Today': 'Not implemented',
      'Value 5': '',
      'Value 6': '',
      'Value 7': '',
      'Value 8': '',
    };

    if (history.monthlyCost[0] != null) {
      infoMap['Monthly Cost'] = history.monthlyCost.last!.cost.toString();
    }
    
    if (history.dailyEarnings.isNotEmpty) {
      // round this value to the nearest 2 decimal places
      var dailyEarningsLastValue = history.dailyEarnings.values.last![0];
      String dailyEarningsLastValueString =
          dailyEarningsLastValue.toStringAsFixed(2);
      infoMap['Daily Earn'] = dailyEarningsLastValueString;


    }



    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapRow(
          children: infoMap.entries
              .where((entry) => entry.key != 'time')
              .map((entry) => BootstrapCol(
                    fit: FlexFit.tight,
                    sizes: 'col-12 col-sm-3',
                    child: GenericCard(
                      propertyName: entry.key,
                      propertyValue: entry.value,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
