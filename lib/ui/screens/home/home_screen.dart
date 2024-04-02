import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/components/info_card.dart';
import 'package:testapp/ui/screens/home/nodeinfo_card.dart';
import 'package:testapp/ui/components/last_refresh_card.dart';
import 'package:testapp/ui/components/bottom_bar.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/api/services/fetchInfo.dart';

final storage = FlutterSecureStorage();

class HomeScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  HomeScreen({
    Key? key,
  }) : super(key: key, title: 'Home');
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends SimpleScreenState<HomeScreen>
    with GetItStateMixin {
      late bool isTokenValid;

  @override
  void initState() {
    // Check if the token is valid.
    // read from storage


    isTokenValid = GetIt.I<NodeManagerInfo>().isLoggedIn;
    print('isloggedin inside homescreen: $isTokenValid');

    super.initState();
    bootstrapGridParameters(gutterSize: 20);


  }

  // read token from storage async
  // check if token is valid
  // if valid, return homePage

  // Future<String> readToken() async {
  //   final String? jwt = await storage.read(key: "jwt");
  //   return jwt!;
  // }

  Future<bool> checkLogin() async {
    print('checkinglogin');

    final String? jwt = await storage.read(key: "jwt");
    if (jwt == null) {
      GetIt.I<NodeManagerInfo>().isLoggedIn = false;
      isTokenValid = false;
    } else {
      GetIt.I<NodeManagerInfo>().isLoggedIn = true;
      isTokenValid = true;
      GetIt.I<NodeManagerInfo>().setToken(jwt);
    }
    print('jwt3: $jwt');

    // TODO: We dont want to fetch info here, 
    // so we need to figure out why the info doesn't stick around after REFRESH
    if (isTokenValid) {
      await InfoService().fetchInfo(); 
    }
    await Future.delayed(Duration(milliseconds: 500));

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
            return homePage(context);
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


    checkLogin();
    if (isTokenValid) {
      print('buildchild token is valid: $isTokenValid');
      return homePage(context);
    } else {
      // Directly navigate to the login page if the token is not valid.
      Future.microtask(() => context.go('/')); 
      return Container(); // Return an empty container to avoid any temporary rendering issues.
    }
  }

  BootstrapContainer homePage(context) {
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.82,
            height: MediaQuery.of(context).size.height * 0.68,
            child: NodeInfoCard(),
          ),
        ),
        BootstrapRow(
          children: [
            BootstrapCol(
              sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
              child: BottomBar(),
            ),
          ],
        ),
      ],
    );
  }
}
