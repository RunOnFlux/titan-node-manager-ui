import 'package:flutter/material.dart';
import 'package:testapp/ui/components/last_refresh_card.dart';
import 'package:testapp/ui/components/logout_card.dart';
import 'package:testapp/ui/components/add_address.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback rebuild;

  BottomBar({required this.rebuild});
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LastRefresh(),
          Row(children: [
            AddAddress(rebuild: rebuild),
            LogoutCard(),
          ])
        ],
      ),
    );
  }
}
