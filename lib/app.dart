// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/themes.dart';
import 'package:tic_tac_toe/test/test_1.dart';
import 'package:tic_tac_toe/views/screens/home.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: const Home(),
    );
  }
}