// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/settings.dart';

// - * Create a table item for the inactive transactions.

// - * This can be its own list item from the menu on the right.

// - * The table will look simlar to the current table except the first column will be a button that says start fluxnode.

// - * When clicked this will send the command to the backend server api for starting a fluxnode.

// - * Lets also get the response from the server add display it to the user with a pop up message card.

// - * On the homepage, lets add a last refeshed time (that shows that time from when this data was fetched)

// - * Can we make the ip addresses clickable and if clicked they would open a tab to the fluxnode server on that ip address. example = http://ipaddresshere:16126/

// - * Can we make the text on inactive nodes red

// - * Can we make the text on active nodes green

// - * Change the named of Running Flux to - Collateralized Total

// - * Lets add a label to next payment number that says blocks or minutes depending on what the number means. If it is an estimated use a ~

// - * See if you can create filters on the table headers. For example. If I was to click Tier it would sort by the other Tiers

// - See if you can add a search bar to the table(s) that allow you to search for IP Address, Tier, Collateral.
void main() async {
  GetIt.I.registerSingleton<NodeManagerInfo>(NodeManagerInfo());
  await NodeManagerSettings().initialize();

  runApp(NodeManagerApp());
}
