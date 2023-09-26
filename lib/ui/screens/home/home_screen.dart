import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/screens/home/info_card.dart';
import 'package:testapp/ui/screens/home/nodeinfo_card.dart';
import 'package:testapp/ui/screens/home/last_refresh_card.dart';

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
      // decoration:
      //     BoxDecoration(border: Border.all(color: Colors.white, width: 4)),
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
        Container(
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.white, width: 4)),
          child: SizedBox(
            width: 4000,
            height: 700,
            child: NodeInfoCard(),
          ),
        ),
        LastRefresh(),
      ],
    );
    // return NodeInfoCard();
  }
  // Widget buildChild(BuildContext context) {
  //   return BootstrapContainer(
  //     fluid: false,
  //     padding: mainPadding(),
  //     children: [
  //       BootstrapRow(
  //         children: [
  //           BootstrapCol(
  //             fit: FlexFit.tight,
  //             sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
  //             child: InfoCard(),
  //           ),
  //         ],
  //       ),
  //       BootstrapCol(
  //         child: NodeInfoCard(),
  //       ),
  //       LastRefresh(),
  //     ],
  //   );
  // }
}
