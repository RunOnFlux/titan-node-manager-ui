import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';

class InfoCard extends StatelessWidget with GetItMixin {
  InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var info = watchOnly((NodeManagerInfo info) => info.info);
    var nodeinfo = watchOnly((NodeManagerInfo nodeinfo) => nodeinfo.nodeinfo);
    return SizedBox(
      height: 300,
      child: UntitledCard(
          padding: EdgeInsets.all(bootStrapValueBasedOnSize(sizes: {
            '': 5.0,
            'sm': 5.0,
            'md': 10.0,
            'lg': 10.0,
            'xl': 10.0,
          }, context: context)),
          child: Column(
            children: [
              Text('Total Flux running: ${info.runningFlux}'),
              Text('Total Flux offline: ${info.inactiveFlux}'),
              Text('Nodes running: ${info.active}'),
              Text('Nodes offline: ${info.inactive}'),
              Text('Cumulus nodes running: ${info.cumulus}'),
              Text('Nimbus nodes running: ${info.nimbus}'),
              Text('Stratus nodes running: ${info.stratus}'),
              Text('Next Payment Window: ${info.nextPaymentWindow}'),
              Text('SOMETHING: ${nodeinfo[0].collateral}'),
            ],
          )),
    );
  }
}
