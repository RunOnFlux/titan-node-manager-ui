import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/components/info_card.dart';
import 'package:testapp/ui/screens/history/history_card.dart';
import 'package:testapp/ui/components/bottom_bar.dart';

import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/screens/history/hist_info_card.dart';
import 'package:testapp/ui/screens/history/hist_graph_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/api/services/fetchInfo.dart';

final storage = FlutterSecureStorage();

class HistoryScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  HistoryScreen({
    Key? key,
  }) : super(key: key, title: 'History');
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends SimpleScreenState<HistoryScreen>
    with GetItStateMixin {
  final isTokenValid = GetIt.I<NodeManagerInfo>().isLoggedIn;
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 20);
  }

  Future<bool> checkLogin() async {
    bool isTokenValid = false;
    final String? jwt = await storage.read(key: "jwt");
    if (jwt == null) {
      GetIt.I<NodeManagerInfo>().isLoggedIn = false;
      isTokenValid = false;
    } else {
      GetIt.I<NodeManagerInfo>().isLoggedIn = true;
      isTokenValid = true;
      GetIt.I<NodeManagerInfo>().setToken(jwt);
    }

    bool isInfoFetched = GetIt.I<NodeManagerInfo>().isInfoFetched;
    if (isTokenValid && !isInfoFetched) {
      await InfoService().fetchInfo();
      await Future.delayed(Duration(milliseconds: 50));
    }

    return isTokenValid;
  }

  @override
  Widget buildChild(BuildContext context) {
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool loggedIn = snapshot.data as bool;
          if (loggedIn) {
            return historyPage(context);
          } else {
            // Directly navigate to the login page if the token is not valid.
            Future.microtask(() => context.go('/'));
            return Container(); // Return an empty container to avoid any temporary rendering issues.
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  BootstrapContainer historyPage(context) {
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapRow(
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
              child: HistInfoCard(),
            ),
          ],
        ),
        BootstrapRow(
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              // chage the size to take up HALF the screen
              sizes: 'col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6',
              child: HistoryCard(),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              // chage the size to take up HALF the screen
              sizes: 'col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6',
              child: HistGraphCard(),
            ),
          ],
        ),
        BootstrapCol(child: BottomBar()),
      ],
    );
  }
}
