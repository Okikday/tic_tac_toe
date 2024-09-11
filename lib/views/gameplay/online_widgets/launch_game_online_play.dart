// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/colors.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/common/widgets/custom_alert_dialog.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/online_play.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<OnlineProvider>(context, listen: false).onlineLoadGame(context);
    });
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
            IconButton(

              onPressed: (){
              
              showDialog(context: context, builder: (context) => CustomAlertDialog(title: "End game?",
                actions: [
                MaterialButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Cancel"),),
                MaterialButton(
                  color: MyColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                  onPressed: (){
                  final String userID = Provider.of<DeviceProvider>(context, listen: false).userId;
                  final String gameplayID = Provider.of<OnlineProvider>(context, listen: false).currentOnlineGameplayID;
                  OnlinePlay(context).endOnlineGame(userID, gameplayID);
                }, child: Text("End Game"),),
              ]));
            }, icon: Icon(Icons.cancel_rounded, size: 36, color: Colors.red,),),
            ProgressTrackboard(),
            OnlineGridboard3By3(),
          ],
        ),
      ),
    );
  }
}
