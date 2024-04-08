import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/settings.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  GetIt.I.registerSingleton<NodeManagerInfo>(NodeManagerInfo());
  await NodeManagerSettings().initialize();
  setUrlStrategy(PathUrlStrategy());

  runApp(NodeManagerApp());
}
