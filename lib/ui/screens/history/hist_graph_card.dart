import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/generic_card.dart';

class HistGraph extends StatelessWidget with GetItMixin {
  HistGraph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {


    // return Container(child: Text(),)



 return BootstrapContainer(
  fluid: true,
  children: [
    BootstrapRow(
      height: MediaQuery.of(context).size.height * 0.35,
      children: [
        BootstrapCol(
          fit: FlexFit.tight,
          sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                // make the graph size dependent on the screen size
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Text('Graph-1 goes here'),
              ),
            ),
          ),
        ),
      ]
    ),
    BootstrapRow(
      height: MediaQuery.of(context).size.height * 0.35,
      children: [
        BootstrapCol(
          fit: FlexFit.tight,
          sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12',
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                // make the graph size dependent on the screen size
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Text('Graph-2 goes here'),
              ),
            ),
          ),
        ),
      ]
    ),
  ],
);

}
}