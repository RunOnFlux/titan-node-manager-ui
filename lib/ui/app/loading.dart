import 'package:collection/collection.dart';
import 'package:flutter_base/ui/app/i18n.dart';
import 'package:flutter_base/ui/app/loading_notifier.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/api/services/fetchInfo.dart';
import 'package:testapp/ui/app/app.dart';

class NodeManagerLoadingNotifier extends LoadingNotifier {
  static int lastRefresh = 0;

  @override
  Future<void> fetchData() async {
    var info = await InfoService().fetchInfo();
    var nodeinfo = await InfoService().fetchNodeInfo();
    var inactiveInfo = await InfoService().fetchInactiveInfo();
    GetIt.I<NodeManagerInfo>().info = info;
    GetIt.I<NodeManagerInfo>().nodeinfo = nodeinfo;
    GetIt.I<NodeManagerInfo>().inactiveInfo = inactiveInfo;
    GetIt.I<NodeManagerInfo>().lastRefresh = info.time;

    loadingComplete = true;
    notifyListeners();
  }
}
