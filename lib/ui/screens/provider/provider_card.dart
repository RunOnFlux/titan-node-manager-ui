// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it/get_it.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/utils/config.dart';
import 'package:testapp/ui/screens/login/login_card.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:testapp/api/model/info.dart';

class ProviderPage extends StatelessWidget with GetItMixin {
  ProviderPage({super.key});
  @override
  Widget build(BuildContext context) {
    var providersList =
        watchOnly((NodeManagerInfo info) => info.info.providers);
    // make a copy of the providers list so we don't modify the original
    List<String> providers = List<String>.from(providersList);
    return _ProviderTable(providers);
  }
}

class _ProviderTable extends StatefulWidget {
  final List<String> providers;

  const _ProviderTable(this.providers);

  @override
  _ProviderTableState createState() => _ProviderTableState(providers);
}

class _ProviderTableState extends State<_ProviderTable> {
  _ProviderTableState(this.providers);
  List<String> providers;

  @override
  Widget build(BuildContext context) {
    processProviders();
    return BootstrapContainer(
      fluid: true,
      children: [
        BootstrapCol(
          sizes: 'col-12 col-sm-3 col-md-3 col-lg-3 col-xl-3',
          child: SizedBox(
            height: 50,
            width: 100,
            child: ElevatedButton(
              child: Text('Add Provider'),
              onPressed: () {
                providerPopup(context);
              },
            ),
          ),
        ),
        BootstrapCol(
          //  White space
          sizes: 'col-12 col-sm-6 col-md-9 col-lg-9 col-xl-9',
          child: const SizedBox(height: 50),
        ),
        BootstrapCol(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: _buildProviderTable()),
        )
      ],
    );
  }

  void processProviders() {
    providers.remove('ADD NEW');
    providers.remove('--');
  }

  Widget _buildProviderTable() {
    return DataTable(
      columns: [
        DataColumn(
          label: Text('Provider'),
        ),
        DataColumn(
          label: Text('Nodes'),
        ),
        DataColumn(
          label: Text('Price'),
        ),
        DataColumn(
          label: Text(''),
        ),
      ],
      rows: providers.map<DataRow>(
        (provider) {
          return DataRow(
            cells: [
              DataCell(Text(provider)),
              DataCell(Text('#nodes')),
              DataCell(Text('price')),
              DataCell(ElevatedButton(
                child: Text('Remove provider'),
                onPressed: () {
                  removeProvider(provider);
                },
              )),
            ],
          );
        },
      ).toList(),
    );
  }

  void providerPopup(context) {
    String providerToBeCreated = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(
              onChanged: (provider) {
                providerToBeCreated = provider;
              },
              onSubmitted: (provider) async {
                var response = await addProvider(providerToBeCreated);
                print('Response: $response');
                Navigator.of(context).pop();
              },
            ),
            actions: [],
          );
        });
  }

  Future<String> addProvider(String provider) async {
    String? jwt = await storage.read(key: "jwt");
    jwt ??= '';

    Map<String, String> requestBody = {
      'provider': provider,
    };
    var url = Uri.parse('${AppConfig().apiEndpoint}/provider');

    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      },
    );

    print('Response: ${response.body}');

    if (response.body == 'Provider added') {
      providers.add(provider);
      providers.toSet().toList(); // remove duplicates
    }

    if (response.body == '') {
      providers.add(provider);
    }

    setState(() {});

    return response.body;
  }

  Future<String> removeProvider(String provider) async {
    String? jwt = await storage.read(key: "jwt");
    jwt ??= '';

    Map<String, String> requestBody = {
      'provider': provider,
    };

    var url = Uri.parse('${AppConfig().apiEndpoint}/removeprovider');

    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $jwt"
      },
    );

    print('Response: ${response.body}');

    if (response.body == 'Provider removed') {
      providers.remove(provider);
      providers.toSet().toList();
      updateNodes(provider);

      setState(() {});
    }

    return response.body;
  }

  void updateNodes(provider) {
    List<NodeInfo> nodeinfo = GetIt.I<NodeManagerInfo>().nodeinfo;
    // change the provider of all nodes with the removed provider to '--'
    for (var node in nodeinfo) {
      if (node.provider == provider) {
        node.provider = '--';
      }
    }
  }
}
