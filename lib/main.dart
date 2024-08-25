import 'package:flutter/material.dart';
import 'package:tic_tac_toe/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_tac_toe/models/grid_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GridProvider())
    ],

    child: const App(),
    
    ));

}


