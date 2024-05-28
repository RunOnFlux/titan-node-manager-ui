# titan-node-manager-ui
This is the frontend Flutter code for the Node Manager App. It displays all active and inactive nodes associated with a user. A user must sign up with a valid address and can add more addresses for the manager to track.


# Run the code

## Requirements to run
- Flutter Installation https://docs.flutter.dev/get-started/install
- `flutter doctor`  
Verify installation

## Commands to run
- `flutter run`  
Points to development backend
- `flutter run --release`  
Points to production backend
- `r`  
Hot reload
- `R`  
Hot restart

### Remake .g files from models
- Run this command anytime you change any of the model files (lib/api/model/)  
`flutter pub run build_runner build --delete-conflicting-outputs`


# Codebase

## Fetch Info
The jwt logic and pulling from backend apis is done in lib/api/services/fetchInfo.dart  
We hit 4 apis for data: /nodeinfo, /inactive, /macroInfo, /history  

## Navigation
There are four available pages once the user has logged in: Home, Inactive, History, and Providers.

### Home Page
The home page builds a table with the active nodes and displays node metrics at the top of the screen

### Inactive
The inactive page builds a table with the inactive nodes and displays node metrics at the top of the screen

### History
The history page displays recent node drop events, node drops per provider per month, recent daily losss, and historical node metrics.

### Providers
The Providers page is a simple way to keep track of which providers are associated with the user account. They can easily see a list of providers and there are clear options to add/remove providers.


# Help
- Flutter documentation https://docs.flutter.dev/
