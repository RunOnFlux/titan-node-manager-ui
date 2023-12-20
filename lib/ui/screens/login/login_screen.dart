import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/screens/login/login_card.dart';


class LoginScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  LoginScreen({Key? key}) : super(key: key, title: 'Login');

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends SimpleScreenState<LoginScreen>
    with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 20);
  }

  @override
  Widget buildChild(BuildContext context) {
    return SizedBox(child: LoginPage(),
    width: 500,
    height: 500,);
  }

}
