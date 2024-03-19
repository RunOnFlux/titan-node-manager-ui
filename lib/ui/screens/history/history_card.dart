import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/save_card.dart';
import 'package:testapp/ui/screens/history/activity_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:testapp/api/model/history.dart';
import 'package:testapp/api/model/history.dart';

class HistoryCard extends StatelessWidget with GetItMixin {
  HistoryCard({super.key});
  @override
  Widget build(BuildContext context) {
    var history =
        watchOnly((NodeManagerInfo nodeManagerInfo) => nodeManagerInfo.history);
    var nodeActivity = history.nodeActivity;

    return NodeActivity(nodeActivity.cast<NodeEvent>());
  }
}
