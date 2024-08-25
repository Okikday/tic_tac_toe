import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/themes.dart';
import 'package:tic_tac_toe/views/gameplay/play_with_comp.dart';
import 'package:tic_tac_toe/views/screens/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: PlayWithComp(),
    );
  }
}