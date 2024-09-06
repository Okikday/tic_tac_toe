import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/services/device_provider.dart';

class OnlinePlay {
  final DatabaseReference _gameSessionRef;
  final DatabaseReference _onlinePlayersRef;

  OnlinePlay()
      : _gameSessionRef = FirebaseDatabase.instance.ref('gameSessions'), // write that game session
      _onlinePlayersRef = FirebaseDatabase.instance.ref('onlinePlayers');

  

  void requestGamePlay(context, {required String myUID, required String otherPlayerUID, String? choice, int? gridType, })async{
    final DataSnapshot checkIfRequestExist = await _onlinePlayersRef.child("$otherPlayerUID/requests").get();
    if(checkIfRequestExist.exists){

    }
    else{
      final String gameplayId = DateTime.now().millisecondsSinceEpoch.toString();
    final DataSnapshot myDataSnapshot = await _onlinePlayersRef.child(myUID).get();
    final DataSnapshot otherPlayerDataSnapshot = await _onlinePlayersRef.child(otherPlayerUID).get();
    String? myName = myDataSnapshot.child("name").value.toString();
    String? myPhoto = myDataSnapshot.child("photoURL").value.toString();
    String? otherPlayerName = otherPlayerDataSnapshot.child("name").value.toString();
    String? otherPlayerPhotoURL = otherPlayerDataSnapshot.child("photoURL").value.toString();
    String? otherPlayerStatus = otherPlayerDataSnapshot.child("status").value.toString();
    Provider.of<DeviceProvider>(context, listen: false).setCurrentOnlineGameplayID(gameplayId);
    Map<String, String?> gameplayList;
    if(gridType == 5){
      gameplayList = {
        for(int i = 0; i < SharedPrefsData1.defaultGameplayListGrid5.length; i++) i.toString(): SharedPrefsData1.defaultGameplayListGrid5[i].toString()
      };
      
    }else if(gridType == 4){
       gameplayList = {
        for(int i = 0; i < SharedPrefsData1.defaultGameplayListGrid4.length; i++) i.toString(): SharedPrefsData1.defaultGameplayListGrid4[i].toString()
      };
    }else{
       gameplayList = {
        for(int i = 0; i < SharedPrefsData1.defaultGameplayListGrid3.length; i++) i.toString(): SharedPrefsData1.defaultGameplayListGrid3[i].toString()
      };
    }


    await _gameSessionRef.child(gameplayId).set({
      'player1' : {
        'userName': myName,
        'uid': myUID,
        'photoURL' : myPhoto,
        'choice': "X",
        'status': "online"
        },
      'player2' : {
        'userName': otherPlayerName,
        'uid': otherPlayerUID,
        'photoURL' : otherPlayerPhotoURL,
        'choice': "O",
        'status': otherPlayerStatus,
      },
      'score' : {
        'player1' : 0,
        'player2': 0
      },
      'hasOtherUserAccepted' : false,
      'gridType' : gridType ?? 3,
      'currentWinBy' : "",
      'endedSession' : false,
      'gameplayList' : gameplayList,
    });

    await _onlinePlayersRef.child("$otherPlayerUID/requests/").update({
      gameplayId : ""
    });
    await _onlinePlayersRef.child("$myUID/sentRequests/").update({
      gameplayId : ""
    });
    }
  }

  void checkGameRequests({required String myUID,}) async{
    await _onlinePlayersRef.child(myUID).child("requests").get();
  }

}