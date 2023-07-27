import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/app/loading.dart' as loading;
import 'dart:math';

import 'info_prop_card.dart';

class LastRefresh extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    final lastRefreshTime = watchOnly((NodeManagerInfo x) => x.lastRefresh);

    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      builder: (context, snapshot) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final secondsElapsed = ((now - lastRefreshTime) / 1000).floor();
        return Text('Last Refresh: $secondsElapsed seconds');
      },
    );
  }
}
