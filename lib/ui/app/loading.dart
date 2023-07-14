import 'package:collection/collection.dart';
import 'package:flutter_base/ui/app/i18n.dart';
import 'package:flutter_base/ui/app/loading_notifier.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/api/services/info.dart';
import 'package:testapp/ui/app/app.dart';

class NodeManagerLoadingNotifier extends LoadingNotifier {
  @override
  Future<void> fetchData() async {
    var info = await InfoService().fetchInfo();
    var nodeinfo = await InfoService().fetchNodeInfo();
    GetIt.I<NodeManagerInfo>().info = info;
    GetIt.I<NodeManagerInfo>().nodeinfo = nodeinfo;

    loadingComplete = true;
    notifyListeners();
  }
}
