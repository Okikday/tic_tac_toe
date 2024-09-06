import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/themes.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/grid_board_4_by_4.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/play_online.dart';
import 'package:tic_tac_toe/views/screens/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: Home(),
      //PlayOnline(gridType: 3, myChoice: 1, gameplayID: "1725567654356")
    );
  }
}