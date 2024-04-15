import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/loading_notifier.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:provider/provider.dart';
import 'package:testapp/api/model/history.dart';
import 'package:testapp/api/model/info.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/inactiveInfo.dart';

import 'package:testapp/ui/app/router.dart';

import '../../utils/settings.dart';
import 'loading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

class NodeManagerApp extends MinimalApp {
  NodeManagerApp({Key? key})
      : super(
            key: key,
            router: NodeManagerRouter(),
            settings: NodeManagerSettings());

  @override
  registerTheme() {
    // TODO: implement registerTheme
    return super.registerTheme();
  }

  @override
  State<NodeManagerApp> createState() => NodeManagerAppState();
}

class NodeManagerAppState extends MinimalAppState<NodeManagerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  String get initialWindowTitle => 'Node Manager';
  @override
  String get windowTitle => 'Node Manager';
  @override
  NodeManagerLoadingNotifier get loadingNotifier =>
      NodeManagerLoadingNotifier();

  @override
  Widget buildMainApp(BuildContext context) {
    print('Building main app');
    var loadingNotifier =
        (Provider.of<LoadingNotifier>(context) as NodeManagerLoadingNotifier);
    

    Widget mainApp = super.buildMainApp(context);

    //NotificationService().setupFlutterNotifications();
    //NotificationService().router = router;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: loadingNotifier),
      ],
      child: mainApp,
    );
  }

  @override
  AppConfig get config => NodeManagerAppConfig();
}

class NodeManagerInfo with ChangeNotifier {
  String _token = '';
  bool isLoggedIn = false;

  String get token => _token;

  void setToken(String newToken) {
    _token = newToken;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = '';
    isLoggedIn = false;
    await secureStorage.delete(key: "jwt");
    notifyListeners();
  }

  late Info info;
  late List<NodeInfo> nodeinfo;
  late List<InactiveInfo> inactiveInfo;
  late History history;

  bool isInfoFetched = false;
}

class NodeManagerAppConfig extends AppConfig {
  @override
  String getWindowTitle(AppBodyState body, WindowTitle title) {
    return 'Node Manager - ${title.title}';
  }

  @override
  List<Widget> buildTitleWidgets(AppBodyState body, BuildContext context) {
    return [
      AutoSizeText(
        'Node Manager',
        style: Theme.of(context).textTheme.headlineLarge,
        maxLines: 1,
      ),
    ];
  }
}
