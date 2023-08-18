import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/settings.dart';

// Backend

// - Create a new file and preload it with the nodes, name, provider, and price

// - Create a new api endpoint that allows us to modify these values through the UI.

// - Once the new file is ready, when a user requests the nodeinfo (api). Lets combine the new files data (name, provider, price) into the existing result if it exists.

// Frontend

// - Add the name, provider, and price to the table headers. It the valus are set in the data. SHow the updated values, if not. Show a red text saying NOT SET.

// - Create the ability to modify the name, provider, and price, and when it is Saved. The update call when get sent to the backend server.

// Feature ideas
// - Hover effect on info cards
// - It rebuilds the datatable from scratch anytime something happens.
// - Sorting by ip doesn't work
// - No timestamp on inactive table.
// - Authentication for secure features
// - Secure features?

void main() async {
  GetIt.I.registerSingleton<NodeManagerInfo>(NodeManagerInfo());
  await NodeManagerSettings().initialize();

  runApp(NodeManagerApp());
}
