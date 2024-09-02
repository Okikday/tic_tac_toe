import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/services/game_provider_5_by_5.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/grid_board_5_by_5.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/progress_trackboard.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/scoreboard.dart';

class PlayWithComp5By5 extends StatefulWidget {
  const PlayWithComp5By5({super.key});

  @override
  State<PlayWithComp5By5> createState() => _PlayWithComp5By5State();
}

class _PlayWithComp5By5State extends State<PlayWithComp5By5> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GameProvider5by5>(context, listen: false);
      if (provider.playerTurn == null && provider.userChoice == 'O') {
        provider.playGame(context); // Computer plays first
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

           Consumer<GameProvider5by5>(
            builder: (context, provider, child) {
              return Scoreboard(score1: context.watch<GameProvider5by5>().userScore, score2: context.watch<GameProvider5by5>().compScore,);
            }),

           Consumer<GameProvider5by5>(
            builder: (context, provider, child){
            String? userChoice = provider.currentGameUserChoice;
            return ProgressTrackboard(textValue: context.watch<GameProvider5by5>().playerTurn == 1 && userChoice == 'X' || context.watch<GameProvider5by5>().playerTurn == 0 && userChoice == 'O' || context.watch<GameProvider5by5>().playerTurn == null && userChoice == "X" || userChoice == null && provider.userChoice == 'X' ? "Player's turn" : "Computer's turn",);
          }),
          Consumer(builder: (context, provider, child){
            return GridBoard5by5(boardTexts: context.watch<GameProvider5by5>().boardTexts, onpressed: (index){
               context.read<GameProvider5by5>().playGame(context, pos: index);
            });
          })
        ],
      ),
    );
  }
}