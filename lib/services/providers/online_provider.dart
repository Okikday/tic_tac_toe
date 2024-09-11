import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/models/gameplay.dart';

final DatabaseReference gameSessionRef = FirebaseDatabase.instance.ref('gameSessions');
class OnlineProvider extends ChangeNotifier{
  
  String _currentOnlineGameplayID = '';
  List<dynamic> _gameplayList = [];
  List<String?> _boardTexts = [];
  int score1 = 0;
  int score2 = 0;
  String _userChoice = '';
  int _count = 0;
  bool _myTurn = false;

  int get userScore => score1;
  int get otherPlayerScore => score2;
  String get userChoice => _userChoice;
  int get count => _count;
  String get currentOnlineGameplayID => _currentOnlineGameplayID;
  bool get myTurn => _myTurn;

  Future<void> initOnlineProvider() async{
    
    notifyListeners();
  }

  void updateGameplayList(List<dynamic> gameplayList){
    _gameplayList = gameplayList;
    for(int i = 0; i < _gameplayList.length; i++){
      if(gameplayList[i] == null || gameplayList[i] == "null"){
        _boardTexts.add(null);
      }else if(gameplayList[i] == 0 || gameplayList[i] == "0"){
        _boardTexts.add("O");
      }else if(gameplayList[i] == 1 || gameplayList[i] == "1"){
        _boardTexts.add("X");
      }
    }
    notifyListeners();
  }

  List<String?> getBoardTexts() => _boardTexts;

  void setUserChoice(String userChoice) {
    _userChoice = userChoice;
    notifyListeners();
  }

  void resetGameplayList(){
    _gameplayList = [];
    _boardTexts = [];
    notifyListeners();
  }

  void setUserScore(int userScore){
    score1 = userScore;
    notifyListeners();
  }

  void setMyTurn(bool turn){
    _myTurn = turn;
  }

  void setOtherPlayerScore(int otherPlayerScore){
    score2 = otherPlayerScore;
    notifyListeners();
  }

  void setCurrentOnlineGameplayID(String gameplayID){
    _currentOnlineGameplayID = gameplayID;
    notifyListeners();
  }

  void endOnlineGameSession(){
    _gameplayList = [];
    _boardTexts = [];
    score1 = 0;
    score2 = 0;
    _userChoice = '';
    _count = 0;
    _currentOnlineGameplayID = '';
    notifyListeners();
  }

  void resetGameSession(){
    _gameplayList = [];
    _boardTexts = [];
    _count = 0;
    notifyListeners();
  }

  void countGameplayList(){
    _count = 0;
    for(int i = 0; i < _gameplayList.length; i++){
      if(_gameplayList[i] == 0 || _gameplayList[i] == "0"){
        _count++;
      }else if(_gameplayList[i] == 1 || _gameplayList[i] == "1"){
        _count++;
      }else{
        
      }
    }
  }

  void onlinePlayGame(BuildContext context, int index) async{
    countGameplayList();

    if(_count % 2 == 0 && _userChoice == 'X'){
      //X turn
      List<dynamic> newGameList = _gameplayList;
      final DatabaseReference dbReference = FirebaseDatabase.instance.ref('gameSessions/$currentOnlineGameplayID/gameplayList');
      await dbReference.update({
        "$index": "1"
      });
      updateGameplayList(newGameList);
      if(context.mounted) checkGameplay(context);
    }

    if(_count % 2 == 1 && _userChoice == 'O'){
      //X turn
      List<dynamic> newGameList = _gameplayList;
      final DatabaseReference dbReference = FirebaseDatabase.instance.ref('gameSessions/$currentOnlineGameplayID/gameplayList');
      await dbReference.update({
        "$index": "0"
      });
      updateGameplayList(newGameList);
      if(context.mounted) checkGameplay(context);
    }

    //checkgameWin

    notifyListeners();
  }

  void onlineLoadGame(){
    DatabaseReference dbReference = gameSessionRef.child("$currentOnlineGameplayID");

    dbReference.child("gameplayList").onChildChanged.listen((DatabaseEvent event) {
    if(event.snapshot.key != null){
      final int index = int.parse(event.snapshot.key.toString());
      final dynamic value = event.snapshot.value;
      List<dynamic> newGameList = _gameplayList;
      newGameList.insert(index, value);
      updateGameplayList(newGameList);
    }
  });

  dbReference.child("currentWinBy").onChildChanged.listen((DatabaseEvent event){
    event.snapshot.value 
  });

  notifyListeners();
  }


  void checkGameplay(BuildContext context){
    List<int?> newGameList = [];
    for(int i = 0; i < _gameplayList.length; i++){
      if(_gameplayList[i] == "0" || _gameplayList[i] == 0){
        newGameList.add(0);
      }else if(_gameplayList[i] == "1" || _gameplayList[i] == 1){
        newGameList.add(1);
      }else{
        newGameList.add(null);
      }
    }

    final int? winVal = Gameplay().checkWinnerGrid3(newGameList, _count);
    if(winVal == 0){
      if(_userChoice == "X"){
        showDialog(context: context, builder: builder)
      }
    }
    if(winVal == 1){

    }
    if(winVal == null && _count == _gameplayList.length){

    }
  }


}