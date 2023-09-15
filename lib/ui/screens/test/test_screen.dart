import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/screens/home/resizable_table.dart';

class TestScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  TestScreen({Key? key}) : super(key: key, title: 'Home');

  @override
  State<TestScreen> createState() => TestScreenState();
}

class TestScreenState extends SimpleScreenState<TestScreen>
    with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 20);
  }

  @override
  Widget buildChild(BuildContext context) {
    return BootstrapContainer(
      fluid: false,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 4)),
      children: [
        SizedBox(
          width: 4000,
          height: 1000,
          child: TableColumnResize(),
        )
      ],
    );
  }
}
