import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/components/info_card.dart';
import 'package:testapp/ui/screens/history/history_card.dart';
import 'package:testapp/ui/components/last_refresh_card.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/app.dart';

class HistoryScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  HistoryScreen({
    Key? key,
  }) : super(key: key, title: 'Home');
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

  @override
  Widget buildChild(BuildContext context) {
    if (isTokenValid) {
      return historyPage(context);
    } else {

      Future.microtask(() => context.go('/'));
      return Container(); // Return an empty container to avoid any temporary rendering issues.
    }
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
              child: InfoCard(),
            ),
          ],
        ),
        Container(
          child: HistoryCard()),
        LastRefresh(),
      ],
    );
  }

  BootstrapContainer redirectPage(BuildContext context) {
    // this is the page that will be shown if the user is not logged in
    return BootstrapContainer(children: [
      ElevatedButton(
          onPressed: () {
            context.push('/');
          },
          child: Text('Redirect to Home')),
    ]);
  }
}
