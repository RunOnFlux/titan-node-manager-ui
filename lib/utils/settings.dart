import 'package:flutter_base/utils/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NodeManagerSettings extends Settings {
  NodeManagerSettings._p();
  static final NodeManagerSettings _instance = NodeManagerSettings._p();
  factory NodeManagerSettings() => _instance;

  @override
  void writeDefaults(SharedPreferences prefs) {}

  @override
  String get prefix => 'flux';

  // Quick access getters

  static bool get darkMode =>
      NodeManagerSettings().getBool(Setting.darkMode.name, defaultValue: true);
  static String get initialRoute => NodeManagerSettings()
      .getString(Setting.initialRoute.name, defaultValue: '/');
}
