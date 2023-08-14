import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:testapp/ui/app/app.dart';
import 'package:testapp/utils/settings.dart';

// 1.  * Allow the table elements to be clicked and create a pop out of info if they are
// 2. On the inactive Screen.
//     - * Lets move the start node button to the right side of the table
//     - * Add checkboxes on each row, that allow of multiple elements be be checked.
//     - * If multiple are checked a new button pops up that stays "Start Selected Nodes"
//     - * If that button is selected, it loops through and calls the api for each nodes selected. Storing the results and creating a pop out with all the info in a single pop out.
// 3.  * Have the table columns auto scale to the content length
// 4.  * Inactive Nodes Table show vout attribute and address. Remove satoshis height confirmations
// 5.  X Figure out if we can let the user change the size of the tabl6e columns interactively.
// 6.  * Move the search textbox to the right of the screen so it doesn't take up the full width of the table
// 7.  * The last refresh number should come from the info api call on the server

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
