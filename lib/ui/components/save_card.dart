import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/utils/config.dart';

import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:testapp/api/model/inactiveInfo.dart';
import 'package:testapp/api/model/nodeinfo.dart';

import 'package:testapp/ui/screens/login/login_card.dart';

import 'package:flutter/services.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/config.dart';

import 'package:testapp/ui/components/save_node.dart';

class SaveNodeButton extends StatelessWidget with GetItMixin {
  SaveNodeButton({this.node, required this.reset, Key? key}) : super(key: key);

  final dynamic node;
  final VoidCallback reset;

  @override
  Widget build(BuildContext context) {
    var providerList = watchOnly((NodeManagerInfo info) => info.info.providers);
    return _SaveNodeButton(node, reset, providerList, key: key);
  }
}

class _SaveNodeButton extends StatefulWidget {
  final dynamic node;
  final VoidCallback reset;
  final List<String> providerList;

  const _SaveNodeButton(this.node, this.reset, this.providerList, {Key? key})
      : super(key: key);

  @override
  _SaveNodeButtonState createState() =>
      _SaveNodeButtonState(node, reset, providerList, key: key);
}

class _SaveNodeButtonState extends State<_SaveNodeButton> {
  final dynamic node;
  final VoidCallback reset;
  final List<String> providerList;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<String> providers = [];

  _SaveNodeButtonState(this.node, this.reset, this.providerList, {Key? key}) {
    providers = providerList;
  }

  void initDefaultVals() {
    nameController.text = node.name;
    // if (!providers.contains(node.provider.toUpperCase())) {
    //   node.provider = '--';
    // }
    if (node.provider == '') {
      providerController.text = '--';
    }
    providerController.text = node.provider.toUpperCase();
    if (node.price == 0) {
      priceController.text = 'NOT SET';
    } else {
      priceController.text = node.price.toStringAsFixed(2);
    }
  }

  List<DropdownMenuItem<String>> processProviders(List<String> providers) {
    // Place 'ADD NEW' at the front of the list of providers if it's not already there
    if (!providers.contains('ADD NEW')) {
      providers.insert(0, 'ADD NEW');
    }
    // erase any potential duplicates
    providers = providers.toSet().toList();
    // convert all providers to lowercase
    providers = providers.map((provider) => provider.toUpperCase()).toList();

    return providers.map(
      (provider) {
        return DropdownMenuItem(value: provider, child: Text(provider));
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    var processedProviders = processProviders(providers);
    String providerToBeCreated = '';
    String displayProvider = node.provider.toUpperCase();

    initDefaultVals();
    return IconButton(
      // Edit button
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
                  const SizedBox(height: 10), // spacing
                  DropdownButtonFormField<String>(
                      // Provider dropdown
                      value: displayProvider == '' ? '--' : displayProvider,
                      items: processedProviders,
                      onChanged: ((String? selectedDropDown) {
                        if (selectedDropDown == 'ADD NEW') {
                          // Display popup to add new provider
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: TextField(
                                    onChanged: (provider) {
                                      providerToBeCreated = provider;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        providerController.text = '--';
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Submit'),
                                      onPressed: () async {
                                        // setState(() => {});
                                        var response = await addProvider(
                                            providerToBeCreated);
                                        print('Response: $response');
                                        print(
                                            'Submitted new provider: $providerToBeCreated');
                                        displayProvider = providerToBeCreated;

                                        providerController.text =
                                            providerToBeCreated;

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                        providerController.text = selectedDropDown!;
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
                    // providerController.text = displayProvider;
                    if (providerController.text == 'ADD NEW') {
                      providerController.text = '--';
                    }

                    var inputs = {
                      'name': nameController.text,
                      'provider': providerController.text,
                      'price': priceController.text
                    };

                    print('Inputs: $inputs');
                    saveNode(node, inputs, reset);

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

  // Future<http.Response> saveNode(node, inputs) async {
  //   var txhash = (node is NodeInfo)
  //       ? node.txhash
  //       : (node is InactiveInfo)
  //           ? node.txid
  //           : null;
  //   dynamic outidx;

  //   if (node is NodeInfo) {
  //     outidx = int.tryParse(node.outidx);
  //   } else if (node is InactiveInfo) {
  //     outidx = node.vout;
  //   }

  //   Map<String, dynamic> requestBody = {
  //     'txhash': txhash,
  //     'outidx': outidx,
  //     'name': inputs['name'],
  //     'provider': inputs['provider'],
  //     'price': inputs['price'],
  //   };

  //   final String? jwt = await storage.read(key: "jwt");
  //   var url = Uri.parse('${AppConfig().apiEndpoint}/update');
  //   final response = await http.post(
  //     url,
  //     body: jsonEncode(requestBody),
  //     headers: {
  //       HttpHeaders.contentTypeHeader: "application/json",
  //       HttpHeaders.authorizationHeader: "Bearer $jwt"
  //     },
  //   );

  //   if (response.body == 'Update successful') {
  //     node.name = inputs['name'];
  //     node.provider = inputs['provider'];
  //     node.price = double.parse(inputs['price']);
  //     print('UPDATE SUCCESSFUL');
  //     reset();
  //   } else {
  //     print('UPDATE FAILED');
  //   }

  //   return response;
  // }

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

      providers.toSet().toList();
      print('Provider Dropdown added: $provider');

      reset();
      print('Reset accomplished');
    }

    if (response.body == '') {
      providers.add(provider);
      reset();
    }
    return response.body;
  }
}











// return IconButton(
//       icon: const Icon(Icons.edit),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Edit'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   TextFormField(
//                     controller: nameController,
//                     decoration: const InputDecoration(hintText: "Name"),
//                   ),
//                   const SizedBox(height: 10),
//                   DropdownButtonFormField<String>(
//                       value: node.provider == '' ? '--' : node.provider,
//                       items: providers,
//                       onChanged: ((String? x) {
//                         if (x == 'ADD NEW') {
//                           // Display popup to add new provider
//                           showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   content: TextField(
//                                       onSubmitted: (provider) {
//                                         Navigator.of(context).pop();
//                                         showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return AlertDialog(
//                                                 content: Text(
//                                                     'Add new provider: ${provider}'),
//                                                 actions: [
//                                                   TextButton(
//                                                       onPressed: () {
//                                                         Navigator.of(context)
//                                                             .pop();
//                                                       },
//                                                       child: Text('No')),
//                                                   TextButton(
//                                                       onPressed: () async {
//                                                         await addProvider(
//                                                             provider);
//                                                         print(
//                                                             'Submitted new provider: $provider');

//                                                         Navigator.of(context)
//                                                             .pop();
//                                                       },
//                                                       child: Text('Yes')),
//                                                 ],
//                                               );
//                                             });
//                                       },
//                                       decoration: const InputDecoration(
//                                           labelText: "Add provider")),
//                                   actions: [
//                                     TextButton(
//                                         onPressed: () {}, child: const Text(''))
//                                   ],
//                                 );
//                               });
//                         }

//                         providerController.text = x!;
//                       })),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     keyboardType: TextInputType.number,
//                     controller: priceController,
//                     decoration: const InputDecoration(hintText: "Price"),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(
//                           RegExp(r'^\d+\.?\d{0,2}')),
//                     ],
//                   ),
//                 ],
//               ),
//               actions: <Widget>[
//                 ElevatedButton(
//                   child: const Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 ElevatedButton(
//                   child: const Text('Submit'),
//                   onPressed: () {
//                     if (providerController.text == 'ADD NEW') {
//                       providerController.text = '--';
//                     }

//                     var inputs = {
//                       'name': nameController.text,
//                       'provider': providerController.text,
//                       'price': priceController.text
//                     };

//                     saveNode(context, node, inputs);

//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );