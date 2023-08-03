import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';

import 'info_prop_card.dart';

class InfoCard extends StatelessWidget with GetItMixin {
  InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var info = watchOnly((NodeManagerInfo info) => info.info);

    var infoMap = {
      'Collateralized Total': info.runningFlux,
      'Inactive Flux': info.inactiveFlux,
      'Active Nodes': info.active,
      'Inactive Nodes': info.inactive,
      'Cumulus': info.cumulus,
      'Nimbus': info.nimbus,
      'Stratus': info.stratus,
      'Next Payment (min)': info.nextPaymentWindow,
    };

    return BootstrapContainer(
  fluid: true,
  children: [
    BootstrapRow(
      children: infoMap.entries
        .where((entry) => entry.key != 'time')
        .map((entry) => 
          BootstrapCol(
            fit: FlexFit.tight,
            sizes: 'col-12 col-sm-3',
            child: GenericCard(
              propertyName: entry.key,
              propertyValue: entry.value,
            ),
          )
        ).toList(),
    ),
  ],
);

  }
}
