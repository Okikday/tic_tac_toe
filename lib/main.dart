import 'package:flutter/material.dart';
import 'package:tic_tac_toe/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/services/game_provider.dart';
import 'package:tic_tac_toe/services/shared_prefs.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initPrefs();
  await SharedPrefsData1.initializeAndLoadPreferences();
  final gameProvider = GameProvider(); //seems gotta do this to make sure widgets using this provider are updated at start
  await gameProvider.initGameProvider();
  //final deviceProvider = DeviceProvider(); await deviceProvider.initDeviceProvider;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => gameProvider),
      //ChangeNotifierProvider(create: (context) => deviceProvider),
    ],
    child: const App(),
  ));

}


