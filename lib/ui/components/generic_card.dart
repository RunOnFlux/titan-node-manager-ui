import 'package:flutter/material.dart';

class GenericCard extends StatelessWidget {
  final String propertyName;
  final dynamic propertyValue;

  const GenericCard({
    required this.propertyName,
    required this.propertyValue,
  });

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

  String hoverContent(String propertyName) {
    Map<String, Map> myMap = {
      'Collateralized Total': {
        'Collateralized Total1': '1',
        'Collateralized Total2': '2'
      },
      'Inactive Flux': {'Inactive Flux1': '1', 'Inactive Flux2': '2'},
      'Cumulus': {'Cumulus1': '1', 'Cumulus2': '2'},
      'Nimbus': {'nimbus1': '1', 'nimbus2000': '2000'},
      'Stratus': {'Stratus1': '1', 'Stratus2': '2'},
      'Next Payment (min)': {'Next Payment1': '1', 'Next Payment2000': '2'},
      'Active Nodes': {'Active Nodes1': '1', 'Active Nodes2': '2'},
      'Inactive Nodes': {'Inactive Nodes1': '1', 'Inactive Nodes2000': '2'},
    };

    String output = '';

    for (var entry in myMap[propertyName]!.entries) {
      output += '${entry.key}: ${entry.value}\n';
    }
    output =
        output.substring(0, output.length - 1); // erases newline at the end
    return output;
  }
}
