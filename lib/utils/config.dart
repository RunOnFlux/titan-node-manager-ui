import 'package:flutter/foundation.dart';

class AppConfig {
  static final AppConfig _singleton = AppConfig._internal();
  late final String apiEndpoint;

  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal() {
    if (kDebugMode) {
      apiEndpoint = 'http://localhost:4444/api';
    } else {
      apiEndpoint = 'https://managerbackend.runonflux.io/api';
    }
  }
}
