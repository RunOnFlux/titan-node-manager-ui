import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/screens/home/info_card.dart';

import 'package:testapp/ui/screens/inactive/inactive_card.dart';
import 'package:testapp/ui/screens/home/last_refresh_card.dart';

import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/app.dart';

class InactiveScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  InactiveScreen({Key? key}) : super(key: key, title: 'Inactive');

  @override
  State<InactiveScreen> createState() => InactiveScreenState();
}

class InactiveScreenState extends SimpleScreenState<InactiveScreen>
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
      return inactivePage(context);
    } else {
      // context.push('/');
      return redirectPage(context);
    }
  }

  BootstrapContainer inactivePage(context) {
    return BootstrapContainer(fluid: true, children: [
      BootstrapRow(
        // decoration: BoxDecoration(
        //     border: Border.all(color: Colors.blueGrey, width: 4)),
        children: [
          BootstrapCol(
            fit: FlexFit.tight,
            sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
            child: InfoCard(),
          ),
        ],
      ),
      Container(
        child: SizedBox(
          width: 4000,
          height: 600,
          child: InactiveCard(),
        ),
      ),
      LastRefresh(),
    ]);
  }
}

BootstrapContainer redirectPage(BuildContext context) {
  // this is the page that will be shown if the user is not logged in
  return BootstrapContainer(children: [
    ElevatedButton(
        onPressed: () {
          context.push('/');
          // Navigator.of(context).pushReplacementNamed(
          //   '/home',
          // );
        },
        child: Text('Press to go to login page'))
  ]);
}
