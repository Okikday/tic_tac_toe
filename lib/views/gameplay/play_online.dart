import 'package:flutter/material.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/progress_trackboard.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/scoreboard.dart';

class PlayOnline extends StatefulWidget {
  const PlayOnline({super.key});

  @override
  State<PlayOnline> createState() => _PlayOnlineState();
}

class _PlayOnlineState extends State<PlayOnline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Scoreboard(),
          ProgressTrackboard(),
          //const GridBoard3by3(),
        ],
      ),
    );
  }
}