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
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapRow(
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Running Flux',
                  propertyValue: info.runningFlux),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Inactive Flux',
                  propertyValue: info.inactiveFlux),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Active Nodes', propertyValue: info.active),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Inactive Nodes', propertyValue: info.inactive),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Cumulus', propertyValue: info.cumulus),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Nimbus', propertyValue: info.nimbus),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Stratus', propertyValue: info.stratus),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-3',
              child: GenericCard(
                  propertyName: 'Next Payment',
                  propertyValue: info.nextPaymentWindow),
            ),
          ],
        ),
      ],
    );
  }
}

// class InfoCard extends StatelessWidget with GetItMixin {
//   InfoCard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var info = watchOnly((NodeManagerInfo info) => info.info);
//     return SizedBox(
//       height: 300,
//       child: UntitledCard(
//           padding: EdgeInsets.all(bootStrapValueBasedOnSize(sizes: {
//             '': 5.0,
//             'sm': 5.0,
//             'md': 10.0,
//             'lg': 10.0,
//             'xl': 10.0,
//           }, context: context)),
//           child: Column(
//             children: [
//               Text('Total Flux running: ${info.runningFlux}'),
//               Text('Total Flux offline: ${info.inactiveFlux}'),
//               Text('Nodes running: ${info.active}'),
//               Text('Nodes offline: ${info.inactive}'),
//               Text('Cumulus nodes running: ${info.cumulus}'),
//               Text('Nimbus nodes running: ${info.nimbus}'),
//               Text('Stratus nodes running: ${info.stratus}'),
//               Text('Next Payment Window: ${info.nextPaymentWindow}'),
//               // Text('SOMETHING: ${nodeinfo[0].collateral}'),
//             ],
//           )),
//     );
//   }
// }
