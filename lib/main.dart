import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tic_tac_toe/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_tac_toe/data/initData/hive_data.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/providers/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/services/providers/game_provider_4_by_4.dart';
import 'package:tic_tac_toe/services/providers/game_provider_5_by_5.dart';
import 'package:tic_tac_toe/data/initData/shared_prefs.dart';
import 'package:tic_tac_toe/services/providers/online_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveData.initHiveData();
  await SharedPrefs.initPrefs();
  await SharedPrefsData1.initializeAndLoadPreferences();
  final deviceProvider = DeviceProvider();
  final gameProvider3 = GameProvider3by3(); //gotta do this to make sure widgets using this provider are updated at start
  final gameProvider4 = GameProvider4by4();
  final gameProvider5 = GameProvider5by5();
  final onlineProvider = OnlineProvider();
  await deviceProvider.initDeviceProvider();
  await gameProvider3.initGameProvider3by3();
  await gameProvider4.initGameProvider4by4();
  await gameProvider5.initGameProvider5by5();
  await onlineProvider.initOnlineProvider();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => deviceProvider),
      ChangeNotifierProvider(create: (context) => gameProvider3),
      ChangeNotifierProvider(create: (context) => gameProvider4),
      ChangeNotifierProvider(create: (context) => gameProvider5),
      ChangeNotifierProvider(create: (context) => onlineProvider)
    ],
    child: const App(),
  ));

}


