import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';

import 'package:get_it_mixin/get_it_mixin.dart';

// Pops out when the node row is clicked
// Displays all information about the node
class PopoutCard extends StatelessWidget with GetItMixin {
  PopoutCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // var nodeinfo = watchOnly((NodeManagerInfo nodeinfo) => nodeinfo.nodeinfo);

    List<Map<String, dynamic Function(dynamic)>> attributes = [
      {'IP Address': (node) => node.ip},
      {'Txhash': (node) => node.txhash},
      {'Tier': (node) => node.tier},
      {'Rank': (node) => node.rank.toString()},
      {'Added Height': (node) => node.added_height.toString()},
      {'Confirmed Height': (node) => node.confirmed_height.toString()},
      {'outidx': (node) => node.outidx},
      {'network': (node) => node.network},
      {'last_paid_height': (node) => node.tier},
      {'payment_address': (node) => node.payment_address},
      {'pubkey': (node) => node.pubkey},
      {'activesince': (node) => node.activesince},
      {'lastpaid': (node) => node.lastpaid},
      {'amount': (node) => node.amount},
      {'satoshis': (node) => node.satoshis},
      {'height': (node) => node.height},
      {'confirmations': (node) => node.confirmations},
      {'scriptpubkey': (node) => node.scriptpubkey},
    ];

    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapRow(
            children: attributes.map((attribute) {
          var extractFeature = attribute.values.first;
          return BootstrapCol(child: extractFeature(attribute));
        }).toList()),
      ],
    );
  }
}
