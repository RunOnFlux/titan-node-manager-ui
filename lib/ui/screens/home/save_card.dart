import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/api/model/nodeinfo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/config.dart';

class SaveNodeButton extends StatelessWidget with GetItMixin {
  final dynamic node;
  final VoidCallback reset;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<DropdownMenuItem<String>> providers = [];
  String tempProvider = '';

  SaveNodeButton(this.node, {required this.reset, super.key});

  void initDefaultVals() {
    nameController.text = node.name;
    if (node.provider == '') {
      providerController.text = '--';
    } else {
      providerController.text = node.provider;
    }
    providerController.text = node.provider;
    if (node.price == 0) {
      priceController.text = 'NOT SET';
    } else {
      priceController.text = node.price.toStringAsFixed(2);
    }
  }

  List<DropdownMenuItem<String>> processProviders(List<String> providers) {
    return providers.map(
      (provider) {
        return DropdownMenuItem(value: provider, child: Text(provider));
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    var strProviders = watchOnly((NodeManagerInfo info) => info.info.providers);
    providers = processProviders(strProviders);

    initDefaultVals();
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Edit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                      value: '--',
                      items: providers,
                      onChanged: ((String? x) {
                        if (x == 'ADD NEW') {
                          // Display popup to add new provider
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: TextField(
                                      onSubmitted: (provider) {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(
                                                    'Add new provider: ${provider.toUpperCase()}'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('No')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await addProvider(
                                                            provider);
                                                        print(
                                                            'Submitted new provider: $provider');

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Yes')),
                                                ],
                                              );
                                            });
                                      },
                                      decoration: const InputDecoration(
                                          labelText: "Add provider")),
                                  actions: [
                                    TextButton(
                                        onPressed: () {}, child: const Text(''))
                                  ],
                                );
                              });
                        }

                        providerController.text = x!;
                      })),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: const InputDecoration(hintText: "Price"),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (providerController.text == 'Add new') {
                      providerController.text = '--';
                    }

                    var inputs = {
                      'name': nameController.text,
                      'provider': providerController.text,
                      'price': priceController.text
                    };

                    saveNode(context, node, inputs);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<http.Response> saveNode(BuildContext context, node, inputs) async {
    var txhash = (node is NodeInfo)
        ? node.txhash
        : (node is InactiveInfo)
            ? node.txid
            : null;
    dynamic outidx;

    if (node is NodeInfo) {
      outidx = int.tryParse(node.outidx);
    } else if (node is InactiveInfo) {
      outidx = node.vout;
    }
    print('typeof price: ${node.price.runtimeType}');

    Map<String, dynamic> requestBody = {
      'txhash': txhash,
      'outidx': outidx,
      'name': inputs['name'],
      'provider': inputs['provider'],
      'price': inputs['price'],
    };

    var url = Uri.parse('${AppConfig().apiEndpoint}/update');
    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.body == 'Update successful') {
      node.name = inputs['name'];
      node.provider = inputs['provider'];
      print('typeof price: ${node.price.runtimeType}');
      node.price = double.parse(inputs['price']);
      print('typeof price?: ${double.parse(inputs['price']).runtimeType}');
      print('typeof price: ${node.price.runtimeType}');
      reset();
    } else {
      print('UPDATE FAILED');
    }

    return response;
  }

  Future<String> addProvider(String provider) async {
    Map<String, String> requestBody = {
      'provider': provider,
    };
    var url = Uri.parse('${AppConfig().apiEndpoint}/provider');
    print('provider added: ${provider}');
    final response = await http.post(url,
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'});
    if (response.body == '') {
      providers.add(DropdownMenuItem(value: provider, child: Text(provider)));
      reset();
    }
    return response.body;
  }
}
