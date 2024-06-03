// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:get_it_mixin/get_it_mixin.dart';
// import 'package:testapp/ui/app/app.dart';
// import 'dart:convert';
// import 'package:testapp/utils/config.dart';
// import 'package:testapp/api/services/fetchInfo.dart';
// import 'package:http/http.dart' as http;

// import 'package:go_router/go_router.dart';

// // class FilterAddress extends StatefulWidget {
// //   final VoidCallback rebuild;
// //   final String address;
// //   bool selected = false;

// //   FilterAddress({required this.rebuild, required this.address});
// //   @override
// //   State<FilterAddress> createState() => _FilterAddressState();
// // }

// // class _FilterAddressState extends State<FilterAddress> {
// //   @override
// //   Widget build(BuildContext context) {
// //     print('building filter address for address: ${widget.address}');
// //     return
// //         // color: selected ? Colors.blue : Colors.lightBlue,
// //         ElevatedButton(
// //       style: ButtonStyle(
// //         backgroundColor: MaterialStateProperty.all<Color>(
// //             widget.selected ? Colors.blue : Colors.lightBlue),
// //       ),
// //       onPressed: () {
// //         select();
// //       },
// //       child: Text(widget.address),
// //     );
// //   }

// //   void select() {
// //     print('selecting address: ${widget.address}');
// //     print('selected: ${widget.selected}');
// //     widget.selected = !widget.selected;
// //     widget.rebuild();
// //   }

// //   String getAddress() {
// //     return widget.address;
// //   }
// // }

// class FilterAddress extends StatelessWidget with {
//   final VoidCallback rebuild;
//   final String address;
//   bool selected;

//   FilterAddress({required this.rebuild, required this.address, required this.selected});
//   @override
//   Widget build(BuildContext context) {
//     print('building filter address for address: $address');
//     print('selected: $selected');
//     return
//         // color: selected ? Colors.blue : Colors.lightBlue,
//         ElevatedButton(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all<Color>(
//             selected ? Colors.blue : Colors.lightBlue),
//       ),
//       onPressed: () {
//         select();
//       },
//       child: Text(address),
//     );
//   }

//   void select() {
//     print('selecting address: $address');
//     print('selected: $selected');
//     rebuild();
//   }

//   bool isSelected() {
//     return selected;
//   }

//   String getAddress() {
//     return address;
//   }
// }
