import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/services/game_provider_4_by_4.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/grid_board_4_by_4.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/progress_trackboard.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/scoreboard.dart';

class PlayWithComp4By4 extends StatelessWidget {
  const PlayWithComp4By4({super.key});

  @override
  Widget build(BuildContext context) {
    // final double screenWidth = DeviceUtils.getScreenWidth(context);
    // final double screenHeight = DeviceUtils.getScreenHeight(context);
    return Scaffold(
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           Consumer<GameProvider4by4>(
            builder: (context, provider, child){
            return Scoreboard(score1: context.watch<GameProvider4by4>().userScore, score2: context.watch<GameProvider4by4>().compScore,);
          }),
           Consumer<GameProvider4by4>(
            builder: (context, provider, child){
              String? userChoice = provider.currentGameUserChoice;
            return ProgressTrackboard(textValue: context.watch<GameProvider4by4>().playerTurn == 1 && userChoice == 'X' || context.watch<GameProvider4by4>().playerTurn == 0 && userChoice == 'O' || context.watch<GameProvider4by4>().playerTurn == null && userChoice == "X" || userChoice == null && provider.userChoice == 'X' ? "Player's turn" : "Computer's turn",);
          }),
           const GridBoard4by4(),
        ],
      ),
    );
  }
}