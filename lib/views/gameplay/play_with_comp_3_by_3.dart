import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/services/game_provider_3_by_3.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/grid_board_3_by_3.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/progress_trackboard.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/scoreboard.dart';

class PlayWithComp3By3 extends StatefulWidget {
  const PlayWithComp3By3({super.key});

  @override
  State<PlayWithComp3By3> createState() => _PlayWithComp3By3State();
}

class _PlayWithComp3By3State extends State<PlayWithComp3By3> {
   @override
  void initState() {
    super.initState();

    // Ensure the computer plays first if the user is 'O'
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("Just entered the game");
      final provider = Provider.of<GameProvider3by3>(context, listen: false);
      debugPrint(provider.playerTurn.toString());
      debugPrint(provider.userChoice.toString());
      if (provider.playerTurn == null && provider.userChoice == 'O') {
        provider.playGame(context); // Computer plays first
      }
    });

    
  }
  
  @override
  Widget build(BuildContext context) {
    // final double screenWidth = DeviceUtils.getScreenWidth(context);
    // final double screenHeight = DeviceUtils.getScreenHeight(context);
    return Scaffold(
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Consumer<GameProvider3by3>(
            builder: (context, provider, child){
            return Scoreboard(score1: context.watch<GameProvider3by3>().userScore, score2: context.watch<GameProvider3by3>().compScore, playingWith: "Computer",);
          }),
           Consumer<GameProvider3by3>(
            builder: (context, provider, child){
              String? userChoice = provider.currentGameUserChoice;
            return ProgressTrackboard(textValue: context.watch<GameProvider3by3>().playerTurn == 1 && userChoice == 'X' || context.watch<GameProvider3by3>().playerTurn == 0 && userChoice == 'O' || context.watch<GameProvider3by3>().playerTurn == null && userChoice == "X" || userChoice == null && provider.userChoice == 'X' ? "Player's turn" : "Computer's turn",);
          }),
          Consumer<GameProvider3by3>(
            builder: (context, provider, child){
              return GridBoard3by3(
                boardTexts: context.watch<GameProvider3by3>().boardTexts,
                onpressed: (index){
                  context.read<GameProvider3by3>().playGame(context, pos: index);
                },
              );
          }),
        ],
      ),
    );
  }
}