import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/grid_board_3_by_3.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/progress_trackboard.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/scoreboard.dart';

class PlayWithComp extends StatelessWidget {
  const PlayWithComp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    final double screenHeight = DeviceUtils.getScreenHeight(context);
    return Scaffold(
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Scoreboard(),
          const ProgressTrackboard(textValue: "Player 1 turn",),
          GridBoard3by3(),
        ],
      ),
    );
  }
}