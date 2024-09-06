// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/progress_trackboard.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/scoreboard.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_gridboard_3_by_3.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/someone_wins_dialog.dart';

class PlayOnline extends StatefulWidget {
  final int gridType;
  final String gameplayID;
  final String playAs;
  const PlayOnline({
    super.key,
    this.playAs = 'player1',
    this.gridType = 3,
    this.gameplayID = ''
  });

  @override
  State<PlayOnline> createState() => _PlayOnlineState();
}

class _PlayOnlineState extends State<PlayOnline> {
  late final DatabaseReference query;
  late List<dynamic>? mainGameplayList;

  @override
  void initState() {
    super.initState();
    query = FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/gameplayList");//To be changed to widget.gameplayID late
    print("gameplayID: ${widget.gameplayID}");
    mainGameplayList = SharedPrefsData1.defaultGameplayListGrid3;
  }

  void checkIfWin(context)async{
    DatabaseReference dbGameplayRef = FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/currentWinBy");
    DataSnapshot snapshot = await dbGameplayRef.get();
    if(snapshot.exists){
      if(snapshot.value.toString() == "player1"){
        showDialog(context: context, barrierDismissible: false, builder: (context) => SomeoneWinsDialog(whoWon: "player1", gameplayID: widget.gameplayID));
      }else if(snapshot.value.toString() == "player2"){
        showDialog(context: context, barrierDismissible: false, builder: (context) => SomeoneWinsDialog(whoWon: "player2", gameplayID: widget.gameplayID));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    checkIfWin(context);

    return Scaffold(
      body: StreamBuilder(
        stream: query.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If still loading, show some loading indicator or handle accordingly
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
              // Retrieve gameplayList from Firebase data
              // Update the local list
              
              mainGameplayList = snapshot.data!.snapshot.value as List<dynamic>?;
              print("$mainGameplayList");
            }
             // Build the UI, use mainGameplayList here
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Scoreboard(),
              ProgressTrackboard(),
              OnlineGridboard3By3(gameplayList: mainGameplayList, playAs: widget.playAs, gameplayID: widget.gameplayID),
            ],
          );
          }else{
            return Center(child: MyText().big(context, "Error loading"),);
          }

         
        },
      ),
    );
  }
  }
