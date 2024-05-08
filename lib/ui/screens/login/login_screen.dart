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
  // LoginScreenState() {
  //   InfoService().checkLogin();
  // }
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 20);
  }

  // void checkLogin() async {
  //   final String? jwt = await storage.read(key: "jwt");
  //   if (jwt == null) {
  //     GetIt.I<NodeManagerInfo>().isLoggedIn = false;
  //     return;
  //   }

  //   final bool tokenIsValid = await InfoService().fetchInfo();
  //   if (!tokenIsValid) {
  //     GetIt.I<NodeManagerInfo>().isLoggedIn = false;
  //     return;
  //   }
  //   GetIt.I<NodeManagerInfo>().setToken(jwt);
  //   GetIt.I<NodeManagerInfo>().isLoggedIn = true;
  //   Future.microtask(() => context.go('/home'));
  // }

  @override
  Widget buildChild(BuildContext context) {
    // return SizedBox(
    //   child: LoginPage(),
    //   width: 500,
    //   height: 500,
    // );

    return FutureBuilder(
      future: InfoService().checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool loggedIn = snapshot.data as bool;
          if (loggedIn) {
            print('pushing to home screen');
            context.go('/home');
            return Container();
          } else {
            // Directly navigate to the login page if the token is not valid.
            return SizedBox(
              child: LoginPage(),
              width: 500,
              height: 500,
            ); // Return an empty container to avoid any temporary rendering issues.
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
