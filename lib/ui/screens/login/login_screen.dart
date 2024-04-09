import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/services/fetchInfo.dart';
import 'package:testapp/ui/screens/login/login_card.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/loading.dart';

class LoginScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  LoginScreen({Key? key}) : super(key: key, title: 'Login');

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends SimpleScreenState<LoginScreen>
    with GetItStateMixin {
  // constructor
  LoginScreenState() {
    checkLogin();
  }
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 20);
  }

  void checkLogin() async {
    final String? jwt = await storage.read(key: "jwt");
    if (jwt == null) {
      GetIt.I<NodeManagerInfo>().isLoggedIn = false;
    } else {
      GetIt.I<NodeManagerInfo>().setToken(jwt);
      GetIt.I<NodeManagerInfo>().isLoggedIn = true;
      await InfoService().fetchInfo();
      Future.microtask(() => context.go('/home'));
    }
  }

  @override
  Widget buildChild(BuildContext context) {
    return SizedBox(
      child: LoginPage(),
      width: 500,
      height: 500,
    );
  }
}
