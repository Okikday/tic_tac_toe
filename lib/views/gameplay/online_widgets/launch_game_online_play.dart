// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/providers/online_provider.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/progress_trackboard.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_gridboard_3_by_3.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_scoreboard.dart';

class LaunchGameOnlinePlay extends StatefulWidget {
  final int gridType;
  final String gameplayID;
  final String otherPlayerPhotoURL;
  final String otherPlayerName;
  const LaunchGameOnlinePlay({
    super.key,
    required this.gridType,
    required this.gameplayID,
    required this.otherPlayerPhotoURL,
    required this.otherPlayerName,
  });

  @override
  State<LaunchGameOnlinePlay> createState() => _LaunchGameOnlinePlayState();
}

class _LaunchGameOnlinePlayState extends State<LaunchGameOnlinePlay> {
  late final DatabaseReference query;
  late List<dynamic>? mainGameplayList;

  @override
  void initState() {
    super.initState();
    query = FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/gameplayList"); //To be changed to widget.gameplayID late
    mainGameplayList = SharedPrefsData1.defaultGameplayListGrid3;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OnlineScoreboard(
              otherPlayerPhotoURL: widget.otherPlayerPhotoURL,
              playingWith: widget.otherPlayerName,
              score1: Provider.of<OnlineProvider>(context, listen: false).userScore,
              score2: Provider.of<OnlineProvider>(context, listen: false).otherPlayerScore,
            ),
            ProgressTrackboard(),
            StreamBuilder<DatabaseEvent>(
              stream: null,
              builder: (context, snapshot) {
                
                return OnlineGridboard3By3(boardTexts: Provider.of<OnlineProvider>(context, listen: false).getBoardTexts(),);
              }
            ),
          ],
        ),
      ),
    );
  }
}
