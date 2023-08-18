import 'package:flutter_base/ui/app/loading_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/api/services/fetchInfo.dart';
import 'package:testapp/ui/app/app.dart';

class NodeManagerLoadingNotifier extends LoadingNotifier {
  static int lastRefresh = 0;

  @override
  Future<void> fetchData() async {
    print('loading now');

    var info = await InfoService().fetchInfo();
    var nodeinfo = await InfoService().fetchNodeInfo();
    var inactiveInfo = await InfoService().fetchInactiveInfo();
    print('done loading');

    GetIt.I<NodeManagerInfo>().info = info;
    GetIt.I<NodeManagerInfo>().nodeinfo = nodeinfo;
    GetIt.I<NodeManagerInfo>().inactiveInfo = inactiveInfo;
    GetIt.I<NodeManagerInfo>().lastRefresh = info.time;
    // GetIt.I<NodeManagerInfo>().deepNodes = deepNodes;

    loadingComplete = true;
    notifyListeners();
  }
}
