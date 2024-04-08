import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/ui/components/save_node.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ProviderDropdown extends StatefulWidget {
  final List<String> providers;
  final String selectedProvider;
  final dynamic node;

  final Function(String) onProviderSelected;

  const ProviderDropdown({
    required this.providers,
    required this.selectedProvider,
    required this.node,
    required this.onProviderSelected,
  });

  @override
  _ProviderDropdownState createState() => _ProviderDropdownState();
}

class _ProviderDropdownState extends State<ProviderDropdown> {
  late String _selectedProvider;

  @override
  void initState() {
    super.initState();
    _selectedProvider = widget.selectedProvider.toUpperCase();
    _selectedProvider = removeIfNotInProviders(_selectedProvider);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: _buildDropdownButton(),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButton<String>(
      isExpanded: true,
      iconSize: 0,
      underline: Container(),
      value: _selectedProvider,
      items: processProviders(widget.providers),
      onChanged: (String? provider) {
        if (provider != null) {
          var inputs = {
            'name': widget.node.name,
            'provider': provider,
            'price': widget.node.price.toString(),
          };
          void reset() {
            setState(() {});
          }

          setState(() {
            _selectedProvider = provider;
            widget.onProviderSelected(provider);
            saveNode(widget.node, inputs, reset);
          });
        }
      },
    );
  }

  String removeIfNotInProviders(String provider) {
    List<String> upperCaseProviders =
        widget.providers.map((provider) => provider.toUpperCase()).toList();
    if (!upperCaseProviders.contains(provider)) {
      return '--';
    }
    return provider;
  }

  List<DropdownMenuItem<String>> processProviders(List<String> providers) {
    providers.remove('ADD NEW');
    // erase any potential duplicates
    providers = providers.toSet().toList();
    // convert all providers to lowercase
    providers = providers.map((provider) => provider.toUpperCase()).toList();

    return providers.map(
      (provider) {
        return DropdownMenuItem(
            value: provider,
            child: Text(
                style: TextStyle(
                  fontSize: 13,
                  color: provider == '--' ? Colors.red : Colors.green,
                ),
                provider));
      },
    ).toList();
  }
}
