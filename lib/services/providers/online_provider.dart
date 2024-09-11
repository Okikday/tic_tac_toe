import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/widgets/loading_dialog.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/models/gameplay.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/launch_game_online_play.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/online_game_result_dialog.dart';

final DatabaseReference gameSessionRef = FirebaseDatabase.instance.ref('gameSessions');

class OnlineProvider extends ChangeNotifier {
  String _currentOnlineGameplayID = '';
  List<dynamic> _gameplayList = [];
  List<String?> _boardTexts = [];
  int score1 = 0;
  int score2 = 0;
  String _userChoice = '';
  int _count = 0;
  String _playingAs = '';

  int get userScore => score1;
  int get otherPlayerScore => score2;
  String get userChoice => _userChoice;
  int get count => _count;
  String get currentOnlineGameplayID => _currentOnlineGameplayID;
  String get playingAs => _playingAs;
  List<String?> get boardTexts => _boardTexts;

  Future<void> initOnlineProvider() async {
    notifyListeners();
  }

  void updateGameplayList(List<dynamic> gameplayList) {
    _gameplayList = gameplayList;
    _boardTexts = [];
    for (int i = 0; i < _gameplayList.length; i++) {
      if (gameplayList[i] == null || gameplayList[i] == "null") {
        _boardTexts.add(null);
      } else if (gameplayList[i] == 0 || gameplayList[i] == "0") {
        _boardTexts.add("O");
      } else if (gameplayList[i] == 1 || gameplayList[i] == "1") {
        _boardTexts.add("X");
      }
    }
    notifyListeners();
  }

  

  void setUserChoice(String userChoice) {
    _userChoice = userChoice;
    notifyListeners();
  }

  void resetGameplayList() {
    _gameplayList = [];
    _boardTexts = [];
    notifyListeners();
  }

  void setUserScore(int userScore) {
    score1 = userScore;
    notifyListeners();
  }

  void setPlayingAs(String playingAs) {}

  void setOtherPlayerScore(int otherPlayerScore) {
    score2 = otherPlayerScore;
    notifyListeners();
  }

  void setCurrentOnlineGameplayID(String gameplayID) {
    _currentOnlineGameplayID = gameplayID;
    notifyListeners();
  }

  void endOnlineGameSession() {
    _gameplayList = [];
    _boardTexts = [];
    score1 = 0;
    score2 = 0;
    _userChoice = '';
    _count = 0;
    _currentOnlineGameplayID = '';
    notifyListeners();
  }

  void resetGameSession() {
    _gameplayList = [];
    _boardTexts = [];
    _count = 0;
    notifyListeners();
  }

  void countGameplayList() {
    _count = 0;
    for (int i = 0; i < _gameplayList.length; i++) {
      if (_gameplayList[i] == 0 || _gameplayList[i] == "0") {
        _count++;
      } else if (_gameplayList[i] == 1 || _gameplayList[i] == "1") {
        _count++;
      } else {}
    }
  }

  void onlinePlayGame(BuildContext context, int index) async {
    countGameplayList();
    
    if (_count % 2 == 0 && _userChoice == 'X') {
      //X turn
      
      if(_gameplayList[index] == null || _gameplayList[index] == "null"){
      _gameplayList[index] = "1";
      final DatabaseReference dbReference = FirebaseDatabase.instance.ref('gameSessions/$currentOnlineGameplayID/gameplayList');
      await dbReference.update({"$index": "1"});
      updateGameplayList(_gameplayList);
      if (context.mounted) {
        checkGameplay(context);
        onlineLoadGame(context);
      }
      
      }
      
    }

    if (_count % 2 == 1 && _userChoice == 'O') {
      //O turn
      if(_gameplayList[index] == null || _gameplayList[index] == "null"){
      _gameplayList[index] = "0";
      final DatabaseReference dbReference = FirebaseDatabase.instance.ref('gameSessions/$currentOnlineGameplayID/gameplayList');
      await dbReference.update({"$index": "0"});
      updateGameplayList(_gameplayList);
      if (context.mounted) {
        checkGameplay(context);
        onlineLoadGame(context);
      }
      }
    }

    notifyListeners();
  }

  void onlineLoadGame(BuildContext context){
    print("Online load game");
    DatabaseReference dbReference = gameSessionRef.child(currentOnlineGameplayID);
    dbReference.child("currentWinBy").onValue.drain();
    dbReference.child("endedSession").onValue.drain();
    dbReference.child("gameplayList").onValue.drain();

    dbReference.child("gameplayList").onChildChanged.listen((DatabaseEvent event) {
      if (event.snapshot.key != null) {
        if(event.snapshot.value != "null"){

        final int index = int.parse(event.snapshot.key.toString());
        final dynamic value = event.snapshot.value;
        List<dynamic> newGameList = _gameplayList;
        newGameList[index] = value;
        updateGameplayList(newGameList);

        }
      }
      notifyListeners();
    });

    dbReference.child("currentWinBy").onChildChanged.listen((DatabaseEvent event) async {
      final String otherPlayerPlayingAs = _playingAs == "player1" ? "player2" : "player1";

      if (event.snapshot.value == otherPlayerPlayingAs) {
        if (context.mounted) showDialog(context: context, builder: (context) => const LoadingDialog(canPop: false));
        final DataSnapshot dataSnapshot = await dbReference.child(otherPlayerPlayingAs).get();
        final Map<dynamic, dynamic>? otherUserDataMap = dataSnapshot.value as Map<dynamic, dynamic>?;
        if (otherUserDataMap != null) {
          if (context.mounted) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) => OnlineGameResultDialog(
                    message: "You lose, Cry more 😜", otherPlayerName: otherUserDataMap["userName"], otherPlayerPhotoURL: otherUserDataMap["photoURL"]));
          }
          await dbReference.child("currentWinBy").set("none");
          score2++;
          
        }
      }else if(event.snapshot.value == "none" && _count == 9){
        if (context.mounted) showDialog(context: context, builder: (context) => const LoadingDialog(canPop: false));

        final Map<String, String> resetList = {for (int i = 0; i < SharedPrefsData1.defaultGameplayListGrid3.length; i++) i.toString(): SharedPrefsData1.defaultGameplayListGrid3[i].toString()};
        await dbReference.child("gameplayList").update({
          "gameplayList" : resetList,
        });
        final DataSnapshot dataSnapshot = await dbReference.child(otherPlayerPlayingAs).get();
        final Map<dynamic, dynamic>? otherUserDataMap = dataSnapshot.value as Map<dynamic, dynamic>?;
        if (otherUserDataMap != null) {
          if (context.mounted) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) => OnlineGameResultDialog(
                    message: "No one won", otherPlayerName: otherUserDataMap["userName"], otherPlayerPhotoURL: otherUserDataMap["photoURL"]));
          }
        }
        dbReference.child("currentWinBy").onValue.listen((DatabaseEvent event) {
          if(otherUserDataMap != null){
            if (event.snapshot.value == "newSession") {
            if(context.mounted){
              Navigator.pop(context);
            DeviceUtils.pushMaterialPage(
                context,
                LaunchGameOnlinePlay(
                    gridType: 3,
                    gameplayID: currentOnlineGameplayID,
                    otherPlayerPhotoURL: otherUserDataMap["photoURL"],
                    otherPlayerName: otherUserDataMap["userName"]));
            }
          }
          }
        });
      }
      notifyListeners();
    });

    dbReference.child("endedSession").onValue.listen((DatabaseEvent event) async{
      if(event.snapshot.value == true && context.mounted){
        Navigator.pop(context);
        DeviceUtils.showFlushBar(context, "Game session ended by other user");
        await dbReference.remove();
        
        if (context.mounted) {
          final String userID = Provider.of<DeviceProvider>(context, listen: false).userId;
  if (playingAs == "player1") {
    FirebaseDatabase.instance.ref("onlinePlayers/$userID/sentRequests/$currentOnlineGameplayID").remove();
  } else if (playingAs == "player2") {
    FirebaseDatabase.instance.ref("onlinePlayers/$userID/requests/$currentOnlineGameplayID").remove();
  }
}
      }
      notifyListeners();
    });

    
  }

  void checkGameplay(BuildContext context,) async {
    print("gameplayList: $_gameplayList");
    final List<int?> newGameList = [];

    for (int i = 0; i < _gameplayList.length; i++) {
      if (_gameplayList[i] == "0" || _gameplayList[i] == 0) {
        newGameList[i] = 0;
      } else if (_gameplayList[i] == "1" || _gameplayList[i] == 1) {
        newGameList[i] = 1;
      } else {
        newGameList[i] = null;
      }
    }


    print("$newGameList");
    final int? winVal = Gameplay().checkWinnerGrid3(newGameList, _count);
    if (winVal == 0) {
      if(context.mounted) showDialog(context: context, builder: (context) => const LoadingDialog(canPop: false));
      final String otherPlayerPlayingAs = _playingAs == "player1" ? "player2" : "player1";
      final DataSnapshot dataSnapshot = await gameSessionRef.child("$_currentOnlineGameplayID/$otherPlayerPlayingAs").get();
      final Map<dynamic, dynamic>? otherUserDataMap = dataSnapshot.value as Map<dynamic, dynamic>?;
      
      if (otherUserDataMap != null) {
        if (_userChoice == "O") {
          await gameSessionRef.child("$currentOnlineGameplayID/score/$_playingAs").set(++score1);
          await gameSessionRef.child("$currentOnlineGameplayID/currentWinBy").set(_playingAs);
         if(context.mounted){
          Navigator.pop(context);
           showDialog(
              context: context,
              builder: (context) =>
                  OnlineGameResultDialog(
                    message: "You win", 
                    otherPlayerName: otherUserDataMap["userName"], 
                    otherPlayerPhotoURL: otherUserDataMap["photoURL"]));
         }
        
        }
      }
    }
    if (winVal == 1) {
       if(context.mounted) showDialog(context: context, builder: (context) => const LoadingDialog(canPop: false));
      final String otherPlayerPlayingAs = _playingAs == "player1" ? "player2" : "player1";
      final DataSnapshot dataSnapshot = await gameSessionRef.child("$_currentOnlineGameplayID/$otherPlayerPlayingAs").get();
      final Map<dynamic, dynamic>? otherUserDataMap = dataSnapshot.value as Map<dynamic, dynamic>?;
      
      if (otherUserDataMap != null) {
        if (_userChoice == "X") {
          await gameSessionRef.child("$currentOnlineGameplayID/score/$_playingAs").set(++score1);
          await gameSessionRef.child("$currentOnlineGameplayID/currentWinBy").set(_playingAs);
         if(context.mounted){
          Navigator.pop(context);
           showDialog(
              context: context,
              builder: (context) =>
                  OnlineGameResultDialog(
                    message: "You win", 
                    otherPlayerName: otherUserDataMap["userName"], 
                    otherPlayerPhotoURL: otherUserDataMap["photoURL"]));
         }
        
        }
      }
    }
    if (winVal == null && _count == _gameplayList.length) {
       if(context.mounted) showDialog(context: context, builder: (context) => const LoadingDialog(canPop: false));
      final String otherPlayerPlayingAs = _playingAs == "player1" ? "player2" : "player1";
      final DataSnapshot dataSnapshot = await gameSessionRef.child("$_currentOnlineGameplayID/$otherPlayerPlayingAs").get();
      final Map<dynamic, dynamic>? otherUserDataMap = dataSnapshot.value as Map<dynamic, dynamic>?;
      
      if (otherUserDataMap != null) {
         await gameSessionRef.child("$currentOnlineGameplayID/currentWinBy").set("none");
        if(context.mounted){
          Navigator.pop(context);
           showDialog(
              context: context,
              builder: (context) =>
                  OnlineGameResultDialog(
                    message: "No one wins 💀🗿",
                    otherPlayerName: otherUserDataMap["userName"], 
                    otherPlayerPhotoURL: otherUserDataMap["photoURL"]));
         }
      }
    }
    notifyListeners();
  }
}
