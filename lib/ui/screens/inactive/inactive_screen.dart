import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/screens/home/info_card.dart';

import 'package:testapp/ui/screens/inactive/inactive_card.dart';
import 'package:testapp/ui/screens/home/last_refresh_card.dart';

class InactiveScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  InactiveScreen({Key? key}) : super(key: key, title: 'Inactive');

  @override
  State<InactiveScreen> createState() => InactiveScreenState();
}

class InactiveScreenState extends SimpleScreenState<InactiveScreen>
    with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 20);
  }

  @override
  Widget buildChild(BuildContext context) {
    return BootstrapContainer(
      fluid: true,
      padding: mainPadding(),
      children: [
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
        InactiveCard(),
        LastRefresh(),
      ],
    );
  }
}
