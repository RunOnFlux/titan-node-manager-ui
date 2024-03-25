import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/utils/config.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/api/model/nodeinfo.dart';

import 'package:testapp/ui/screens/login/login_card.dart';

import 'package:flutter/services.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/config.dart';

import 'package:testapp/ui/components/save_node.dart';

class RemoveProvider extends ElevatedButton {}
