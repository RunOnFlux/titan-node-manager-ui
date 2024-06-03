import 'dart:typed_data';

import 'dart:convert';

import 'package:testapp/utils/base58.dart';

bool isValidFluxMainnetAddress(String address) {
  if (address.startsWith("t1") || address.startsWith("t3")) {
    return isValidBase58Address(address);
  }
  return false;
}
