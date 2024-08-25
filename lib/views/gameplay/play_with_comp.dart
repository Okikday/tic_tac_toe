import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/grid_board.dart';
import 'package:tic_tac_toe/views/gameplay/scoreboard.dart';

class PlayWithComp extends StatelessWidget {
  const PlayWithComp({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = DeviceUtils.getScreenWidth(context);
    final double screenHeight = DeviceUtils.getScreenHeight(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Scoreboard(),
            GridBoard(),
          ],
        ),
      ),
    );
  }
}