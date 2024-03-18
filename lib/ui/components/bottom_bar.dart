import 'package:flutter/material.dart';
import 'package:testapp/ui/components/last_refresh_card.dart';
import 'package:testapp/ui/components/logout_card.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LastRefresh(),
          LogoutCard(),
        ],
      ),
    );
  }
}
