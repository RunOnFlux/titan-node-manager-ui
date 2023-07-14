import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/screens/home/info_card.dart';

class HomeScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  HomeScreen({Key? key}) : super(key: key, title: 'Home');

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends SimpleScreenState<HomeScreen>
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
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-12 col-md-12 col-lg-7 col-xl-8',
              child: InfoCard(),
            ),
          ],
        ),
      ],
    );
  }
}
