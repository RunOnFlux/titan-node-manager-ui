import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/screens/home/home_screen.dart';
import 'package:testapp/ui/screens/login/login_screen.dart';
import 'package:testapp/ui/screens/history/history_screen.dart';
import 'package:testapp/ui/screens/provider/provider_screen.dart';

import '../screens/inactive/inactive_screen.dart';
import '../screens/test/test_screen.dart';

class NodeManagerRouter extends AppRouter {
  NodeManagerRouter._p() {
    routes = buildRoutes();
  }
  static final NodeManagerRouter _instance = NodeManagerRouter._p();
  factory NodeManagerRouter() => _instance;

  @override
  List<AbstractRoute> buildRoutes() {
    final routes = <AbstractRoute>[
      NavigationRoute(
        route: '/',
        body: LoginScreen(),
        title: 'Login',
        icon: Icons.login,
        includeInMenu: false,
      ),
      NavigationRoute(
        route: '/home',
        body: HomeScreen(),
        title: 'Home',
        icon: Icons.home,
        includeInMenu: true,
      ),
      NavigationRoute(
        route: '/inactive',
        body: InactiveScreen(),
        title: 'Inactive',
        icon: Icons.build_sharp,
        includeInMenu: true,
      ),
      NavigationRoute(
        route: '/history',
        body: HistoryScreen(),
        title: 'History',
        icon: Icons.history,
        includeInMenu: true,
      ),
      NavigationRoute(
        route: '/provider',
        body: ProviderScreen(),
        title: 'Providers',
        icon: Icons.computer,
        includeInMenu: true,
      ),
    ];
    return routes;
  }

  @override
  List<NavigationRoute> getNavigationRoutes() {
    //List<AbstractRoute> allRoutes = buildRoutes();
    List<NavigationRoute> navRoutes = <NavigationRoute>[];
    for (AbstractRoute r in routes) {
      _addNavigationRoutesFrom(r, navRoutes);
    }
    return navRoutes;
  }

  _addNavigationRoutesFrom(AbstractRoute r, List<NavigationRoute> routes) {
    if (r is NavigationRoute) {
      if (r.privilege != null) {
        PrivilegeLevel? currentLevel = GetIt.I<LoginState>().privilege;
        for (var privilege in r.privilege!) {
          if (privilege == currentLevel) {
            routes.add(r);
            continue;
          }
        }
      } else {
        routes.add(r);
      }
    } else if (r is RouteSet) {
      for (AbstractRoute rr in r.routes) {
        _addNavigationRoutesFrom(rr, routes);
      }
    }
  }
}
