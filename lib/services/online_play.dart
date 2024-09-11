import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/widgets/loading_dialog.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/services/providers/online_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/dialog_game_request_ready.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/launch_game_online_play.dart';

class OnlinePlay {
  final DatabaseReference _gameSessionRef;
  final DatabaseReference _onlinePlayersRef;
  final BuildContext _context;

  OnlinePlay(BuildContext context)
      : _gameSessionRef = FirebaseDatabase.instance.ref('gameSessions'), // write that game session
        _onlinePlayersRef = FirebaseDatabase.instance.ref('onlinePlayers'),
        _context = context;

//Start of Request Gameplay function
  void requestGamePlay({
    required String myUID,
    required String otherPlayerUID,
    String? choice,
    int? gridType,
  }) async {
    
    final DataSnapshot myDataSnapshot = await _onlinePlayersRef.child(myUID).get();
    final DataSnapshot otherPlayerDataSnapshot = await _onlinePlayersRef.child(otherPlayerUID).get();
    
    if (myDataSnapshot.exists && otherPlayerDataSnapshot.exists) {
      
      final DataSnapshot mySentRequests = myDataSnapshot.child("sentRequests");
      final DataSnapshot otherPlayerRequests = otherPlayerDataSnapshot.child("requests");

      
        final otherPlayerRequestKeys = otherPlayerRequests.children.map((child) => child.key).toSet();

        bool hasGamePending = mySentRequests.children.any((child) {
          final key = child.key;
          if (otherPlayerRequestKeys.contains(key)) {
            
            // Check if the value of the common key is "completed"
            final myRequestValue = child.value;
            final otherRequestValue = otherPlayerRequests.child(key!).value;
            return myRequestValue == "completed" || otherRequestValue == "completed";
          }
          return false;
        });

        if (!hasGamePending) {
          await setupGameplayRequest(gridType, myDataSnapshot, myUID, otherPlayerDataSnapshot, otherPlayerUID, choice ?? 'X');
        } else {
          if (_context.mounted) DeviceUtils.showFlushBar(_context, "Request not sent. You probably already have a game session");
        }
    }
  }

  Future<void> setupGameplayRequest(
      int? gridType, DataSnapshot myDataSnapshot, String myUID, DataSnapshot otherPlayerDataSnapshot, String otherPlayerUID, String choice) async {
    final String gameplayId = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, String?> gameplayList;
    if (gridType == 5) {
      gameplayList = {
        for (int i = 0; i < SharedPrefsData1.defaultGameplayListGrid5.length; i++) i.toString(): SharedPrefsData1.defaultGameplayListGrid5[i].toString()
      };
    } else if (gridType == 4) {
      gameplayList = {
        for (int i = 0; i < SharedPrefsData1.defaultGameplayListGrid4.length; i++) i.toString(): SharedPrefsData1.defaultGameplayListGrid4[i].toString()
      };
    } else {
      gameplayList = {
        for (int i = 0; i < SharedPrefsData1.defaultGameplayListGrid3.length; i++) i.toString(): SharedPrefsData1.defaultGameplayListGrid3[i].toString()
      };
    }

    await _gameSessionRef.child(gameplayId).set({
      'player1': {
        'userName': myDataSnapshot.child("name").value.toString(),
        'uid': myUID,
        'photoURL': myDataSnapshot.child("photoURL").value.toString(),
        'choice': choice,
        'status': "online",
      },
      'player2': {
        'userName': otherPlayerDataSnapshot.child("name").value.toString(),
        'uid': otherPlayerUID,
        'photoURL': otherPlayerDataSnapshot.child("photoURL").value.toString(),
        'choice': choice == 'X' ? 'O' : "X",
        'status': otherPlayerDataSnapshot.child("status").value.toString(),
      },
      'score': {'player1': 0, 'player2': 0},
      'hasOtherUserAccepted': false,
      'gridType': gridType ?? 3,
      'currentWinBy': "",
      'endedSession': false,
      'gameplayList': gameplayList,
    });
    await _onlinePlayersRef.child("$otherPlayerUID/requests/").update({gameplayId: "not-completed"});
    await _onlinePlayersRef.child("$myUID/sentRequests/").update({gameplayId: "not-completed"});

    if (_context.mounted) {
      DeviceUtils.showFlushBar(_context, "Successfully sent request, you'll be notified once user accepts");
    }
  }
//End of Request Gameplay function

void acceptGameplay({required String gameplayID}) async{
  showDialog(context: _context, builder: (context) => const LoadingDialog(canPop: false));
  final game = await _gameSessionRef.child("$gameplayID/hasOtherUserAccepted").get();
  if(game.exists){
    await _gameSessionRef.child("$gameplayID/hasOtherUserAccepted").set(true);
    final DataSnapshot dataSnapshot = await _gameSessionRef.child(gameplayID).get();
    final Map<dynamic, dynamic>? dataMap = dataSnapshot.value as Map<dynamic, dynamic>?;
    if (dataSnapshot.exists && dataMap!.isNotEmpty) {
        if (_context.mounted) {
        final List<dynamic> gameplayList = dataMap["gameplayList"];
        Provider.of<OnlineProvider>(_context, listen: false).updateGameplayList(gameplayList);
        Provider.of<OnlineProvider>(_context, listen: false).setUserScore(dataMap["score"]["player2"]);
        Provider.of<OnlineProvider>(_context, listen: false).setOtherPlayerScore(dataMap["score"]["player1"]);
        Provider.of<OnlineProvider>(_context, listen: false).setUserChoice(dataMap["player2"]["choice"]);
        Provider.of<OnlineProvider>(_context, listen: false).setCurrentOnlineGameplayID(gameplayID);
        Provider.of<OnlineProvider>(_context, listen: false).setPlayingAs("player2");
        Navigator.pop(_context);

        DeviceUtils.pushMaterialPage(
              _context,
              LaunchGameOnlinePlay(
                otherPlayerName: dataMap["player1"]["userName"],
                gridType: dataMap["gridType"],
                gameplayID: gameplayID,
                otherPlayerPhotoURL: dataMap["player1"]["photoURL"],
              ));
        
        }
      }
  }


}

void rejectGameplay(String gameplayID, String otherPlayerID, String myUID) async{
    await FirebaseDatabase.instance.ref("onlinePlayer/$otherPlayerID/sentRequests/$gameplayID").remove();
    FirebaseDatabase.instance.ref("onlinePlayer/$myUID/requests/$gameplayID").remove();
    gameSessionRef.child(gameplayID).remove();
    
  }
void endOnlineGame(String userID, String gameplayID){
  Navigator.pop(_context);
  gameSessionRef.child("$gameplayID/endedSession").set(true);
  Future.delayed(const Duration(seconds: 2), (){
    if(_context.mounted){
      final String playingAs = Provider.of<OnlineProvider>(_context, listen: false).playingAs;
    if (playingAs == "player1") {
    FirebaseDatabase.instance.ref("onlinePlayers/$userID/sentRequests/$gameplayID").remove();
  } else if (playingAs == "player2") {
    FirebaseDatabase.instance.ref("onlinePlayers/$userID/requests/$gameplayID").remove();
  }
    }
  });
}


//Start of checking if any waiting request is accepted
  void checkWaitingAccepted({required String myUID}) async {
    if (Provider.of<DeviceProvider>(_context, listen: false).hasCurrentOnlineGameSession == false) {
      final DataSnapshot sentRequestSnapshot = await _onlinePlayersRef.child("$myUID/sentRequests").get();
      Map<dynamic, dynamic>? mySentRequests = sentRequestSnapshot.value as Map<dynamic, dynamic>?;

      if (mySentRequests != null && mySentRequests.isNotEmpty) {
        final List filteredSentRequests = mySentRequests.entries.where((entry) => entry.value != "completed").map((entry) => entry.key).toList();

        String? firstWaitID;
        for (int i = 0; i < filteredSentRequests.length; i++) {
          DataSnapshot acceptedSnapshot = await _gameSessionRef.child("${filteredSentRequests[i]}/hasOtherUserAccepted").get();
          if (acceptedSnapshot.value == true) {
            firstWaitID = filteredSentRequests[i];
            break;
          }
        } //end of for loop

        if (firstWaitID != null) {
          if (_context.mounted) showDialog(context: _context, builder: (context) => const LoadingDialog(canPop: false));
          final DataSnapshot otherUserDataSnapshot = await _gameSessionRef.child("$firstWaitID/player2").get();

          final Map<dynamic, dynamic>? otherUserData = otherUserDataSnapshot.value as Map<dynamic, dynamic>?;
          if (_context.mounted) {
            Navigator.pop(_context);
            showDialog(
                context: _context,
                builder: (context) {
                  return DialogGameRequestReady(
                      otherPlayerName: otherUserData!['userName'], otherPlayerPhotoURL: otherUserData['photoURL'], gameIDToJoin: firstWaitID!);
                });
          }
        }
        
      }
    } else {}
  }
  
void joinPlayerFromGameRequestReady(String gameplayID) async{
  //Add game play logic for game request ready

  Provider.of<DeviceProvider>(_context, listen: false).setCurrentHasOnlineGameSession(true);
  DeviceUtils.pushMaterialPage(_context, const LoadingDialog(canPop: false));
  final DataSnapshot dataSnapshot = await _gameSessionRef.child(gameplayID).get();
  final Map<dynamic, dynamic>? dataMap = dataSnapshot.value as Map<dynamic, dynamic>?;

  
 
  if(dataSnapshot.exists && dataMap!.isNotEmpty){
      if(_context.mounted){
        final List<dynamic> gameplayList = dataMap["gameplayList"];
        Provider.of<OnlineProvider>(_context, listen: false).updateGameplayList(gameplayList);
        Provider.of<OnlineProvider>(_context, listen: false).setUserScore(dataMap["score"]["player1"]);
        Provider.of<OnlineProvider>(_context, listen: false).setOtherPlayerScore(dataMap["score"]["player2"]);
        Provider.of<OnlineProvider>(_context, listen: false).setUserChoice(dataMap["player1"]["choice"]);
        Provider.of<OnlineProvider>(_context, listen: false).setCurrentOnlineGameplayID(gameplayID);
        Provider.of<OnlineProvider>(_context, listen: false).setPlayingAs("player1");

        Navigator.pop(_context);
        DeviceUtils.pushMaterialPage(
          _context,
          LaunchGameOnlinePlay(
            otherPlayerName: dataMap["player2"]["userName"],
            gridType: dataMap["gridType"],
            gameplayID: gameplayID,
            otherPlayerPhotoURL: dataMap["player2"]["photoURL"],
          ));
      }
  }else{
   if(_context.mounted){
     Navigator.pop(_context);
    DeviceUtils.showFlushBar(_context, "Unable to load Gameplay");
   }
  }
   
 
}

}