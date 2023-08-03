import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';

class GenericCard extends StatelessWidget {
  final String propertyName;
  final dynamic propertyValue;

  const GenericCard({required this.propertyName, required this.propertyValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          propertyName,
          style: TextStyle(
            color: propertyName == 'Inactive Nodes'
                ? Colors.red
                : propertyName == 'Active Nodes'
                    ? Colors.green
                    : Colors
                        .white, // Default color when propertyName is neither 'Inactive Nodes' nor 'Active Nodes'
          ),
        ),
        subtitle: Text(propertyValue.toString()),
      ),
    );
  }
}
