import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'dart:convert';
import 'package:testapp/utils/config.dart';
import 'package:testapp/api/services/fetchInfo.dart';

import 'package:go_router/go_router.dart';

class LogoutCard extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      // padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              logout(context);
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    context.go('/');
    GetIt.I<NodeManagerInfo>().logout();
  }
}
