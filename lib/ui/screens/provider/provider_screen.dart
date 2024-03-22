import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/screens/provider/provider_card.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/ui/app/app.dart';

class ProviderScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  ProviderScreen({Key? key}) : super(key: key, title: 'Provider');

  @override
  State<ProviderScreen> createState() => ProviderScreenState();
}

class ProviderScreenState extends SimpleScreenState<ProviderScreen>
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
      return ProviderPage();
    } else {
      Future.microtask(() => context.go('/'));
      return Container();
    }
  }
}
