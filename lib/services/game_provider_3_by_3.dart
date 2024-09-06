import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/models/gameplay.dart';
import 'package:tic_tac_toe/models/generate_play.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/views/gameplay/game_widgets/game_result_dialog.dart';

class GameProvider3by3 extends ChangeNotifier {
  //Offline
  int _count = 0;
  List<int?> _gameplayList = List<int?>.from(SharedPrefsData1.defaultGameplayListGrid3);
  List<String?> _boardTexts = List<String?>.from(SharedPrefsData1.defaultBoardTextsGrid3);
  String _userChoice = 'X';
  int _userScore = 0;
  int _compScore = 0;
  bool _hasCurrentGameSession = false;
  String? _currentGameUserChoice;
  int? _playerTurn;

  // Getters
  List<String?> get boardTexts => _boardTexts;
  int get count => _count;
  String get userChoice => _userChoice;
  int get userScore => _userScore;
  int get compScore => _compScore;
  bool get hasCurrentGameSession => _hasCurrentGameSession;
  int? get playerTurn => _playerTurn;
  String? get currentGameUserChoice => _currentGameUserChoice;

  //Initialize Game provider on app's start
  Future<void> initGameProvider3by3() async {
    _gameplayList = await SharedPrefsData1.getCurrentGamePlayListGrid3();
    _boardTexts = await SharedPrefsData1.getBoardTextsGrid3();
    _userChoice = await SharedPrefsData1.getUserChoice();
    _userScore = await SharedPrefsData1.getUserScore();
    _compScore = await SharedPrefsData1.getCompScore();
    _playerTurn = await SharedPrefsData1.getPlayerTurn();
    _currentGameUserChoice = await SharedPrefsData1.getCurrentGameUserChoice();
    for (var item in _gameplayList) {
      item != null ? _count++ : () {};
    }
    _hasCurrentGameSession = _count > 0;
    notifyListeners();
    debugPrint("Successfully initialized Game Provider");
    debugPrint("List of gameplay: $_gameplayList");
  }

  updateGameplay(){
    
  }



 void playGame(BuildContext context, {int? pos}) async {
  String challengeType = Provider.of<DeviceProvider>(context, listen: false).challengeType;

  if (_playerTurn == null && _hasCurrentGameSession == false && currentGameUserChoice == null) {   

    if(pos == null && _userChoice == 'O'){
      
      
      // Initial setup: Determine the starting player
      _playerTurn = 0; //Meaning X for 1 plays first
      _currentGameUserChoice = _userChoice = await SharedPrefsData1.getUserChoice();
      _hasCurrentGameSession = true; //Modifying has current game session to true
      await SharedPrefsData1.setCurrentGameUserChoice(_currentGameUserChoice);
      debugPrint("Behold, computer plays first");
      if(context.mounted){
        int compPos = 0;
        if(challengeType == 'E'){
          compPos = GeneratePlayGridThree().easyMove(_gameplayList);
        }else if(challengeType == 'M'){
          compPos = GeneratePlayGridThree().mediumMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }else if(challengeType == 'H'){
          compPos = GeneratePlayGridThree().hardMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }else{
          compPos = GeneratePlayGridThree().mediumMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }
        xPlay(context, compPos);
        
      }
    }

    if(pos != null && _userChoice == 'X' && _gameplayList[pos] == null){
      
      _playerTurn = 0;
      _hasCurrentGameSession = true; //Modifying has current game session to true
      _currentGameUserChoice = _userChoice;
      await SharedPrefsData1.setCurrentGameUserChoice(_currentGameUserChoice);

      debugPrint("Behold, User plays at $pos");

      if(context.mounted){
        xPlay(context, pos);
      }

      debugPrint("Guess it's computer turn to play as O");

      Future.delayed(const Duration(milliseconds: 500), () {
        if(context.mounted){
          playGame(context);
        }
      });
    }

  }
   
  if(_playerTurn == 1 && _currentGameUserChoice == 'X' && pos != null && _gameplayList.contains(null) && _gameplayList[pos] == null){
    _playerTurn = 0;
    if(context.mounted){
      xPlay(context, pos);
    }
    //check
    debugPrint("Guess it's computer turn to play as O");
    Future.delayed(const Duration(milliseconds: 500), () {
        if(context.mounted){
          playGame(context);
        }
      });
  }

  if(_playerTurn == 0 && _currentGameUserChoice == 'O' && pos != null && _gameplayList.contains(null) && _gameplayList[pos] == null){
    _playerTurn = 1;
    if(context.mounted){
      oPlay(context, pos);
    }
    //check
    debugPrint("Guess it's computer turn to play as X");
    Future.delayed(const Duration(milliseconds: 500), () {
        if(context.mounted){
          playGame(context);
        }
      });
  }

  if(_playerTurn == 1 && _currentGameUserChoice == 'O' && pos == null && _gameplayList.contains(null)){
    _playerTurn = 0;
    if(context.mounted){
        int compPos = 0;
        if(challengeType == 'E'){
          compPos = GeneratePlayGridThree().easyMove(_gameplayList);
        }else if(challengeType == 'M'){
          compPos = GeneratePlayGridThree().mediumMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }else if(challengeType == 'H'){
          compPos = GeneratePlayGridThree().hardMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }else{
          compPos = GeneratePlayGridThree().mediumMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }
        xPlay(context, compPos);
        
      }
  }

  if(_playerTurn == 0 && _currentGameUserChoice == 'X' && pos == null && _gameplayList.contains(null)){
    _playerTurn = 1;
    if(context.mounted){
        int compPos = 0;
        if(challengeType == 'E'){
          compPos = GeneratePlayGridThree().easyMove(_gameplayList);
        }else if(challengeType == 'M'){
          compPos = GeneratePlayGridThree().mediumMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }else if(challengeType == 'H'){
          compPos = GeneratePlayGridThree().hardMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }else{
          compPos = GeneratePlayGridThree().mediumMove(_gameplayList, _currentGameUserChoice == 'X' ? 0 : 1);
        }
        oPlay(context, compPos);
        
      }
  }
  notifyListeners();
}


//Since X is first
  void xPlay(BuildContext context, int pos) async{

    _gameplayList[pos] = 1;
    _boardTexts[pos] = 'X';
    await SharedPrefsData1.setCurrentGamePlayListGrid3(_gameplayList);
    await SharedPrefsData1.setBoardTextsGrid3(_boardTexts);
    await SharedPrefsData1.setPlayerTurn(_playerTurn);
    _count++;

    notifyListeners();
    
    if(context.mounted){
      checkGameplay(context);
    }
    
  }


  void oPlay(BuildContext context, int pos) async{
    _gameplayList[pos] = 0;
    _boardTexts[pos] = 'O';
    await SharedPrefsData1.setCurrentGamePlayListGrid3(_gameplayList);
    await SharedPrefsData1.setBoardTextsGrid3(_boardTexts);
    await SharedPrefsData1.setPlayerTurn(_playerTurn);
    _count++;

    notifyListeners();

    if(context.mounted){
      checkGameplay(context);
    }

    
  }


  void checkGameplay(BuildContext context) async{
    final int? winVal = Gameplay().checkWinnerGrid3(_gameplayList, _count);

    debugPrint("The check game play: winVal: $winVal");

    if(winVal == 0){
      //O won
      if(_currentGameUserChoice == 'O'){
        _userScore++;
        await SharedPrefsData1.setUserScore(_userScore);
        _playerTurn = null;
        if(context.mounted){
        showDialog(context: context, barrierDismissible: false, builder: (context) => const GameResultDialog(result: "User won",));
        debugPrint("User won");
        
        }
      }else{
        _compScore++;
        await SharedPrefsData1.setCompScore(_compScore);
        _playerTurn = null;
        if(context.mounted){
        showDialog(context: context, barrierDismissible: false, builder: (context) => const GameResultDialog(result: "Computer won",));
        debugPrint("Computer won");
        }
      } 
    }

    if(winVal == 1){
      //X won

      if(_currentGameUserChoice == 'X'){
        _userScore++;
        await SharedPrefsData1.setUserScore(_userScore);
        _playerTurn = null;
        if(context.mounted){
        showDialog(context: context, barrierDismissible: false, builder: (context) => const GameResultDialog(result: "User won",));
        debugPrint("User won");
        
        }
      }else if(_currentGameUserChoice == 'O'){
        _compScore++;
        await SharedPrefsData1.setCompScore(_compScore);
        _playerTurn = null;
        if(context.mounted){
        showDialog(context: context, barrierDismissible: false, builder: (context) => const GameResultDialog(result: "Computer won",));
        debugPrint("Computer won");
        }
      }

    }
    if(winVal == null && count == 9){
       if(context.mounted){
        showDialog(context: context, barrierDismissible: false, builder: (context) => const GameResultDialog(result: "It's a draw",));
        debugPrint("It's a Draw");
        }
    }
    notifyListeners();
  }


  void resetGameSession(BuildContext context) async{
    _count = 0;
    _hasCurrentGameSession = false;
    _playerTurn = null;
    _gameplayList = List<int?>.from(SharedPrefsData1.defaultGameplayListGrid3);
    _boardTexts = List<String?>.from(SharedPrefsData1.defaultBoardTextsGrid3);
    _currentGameUserChoice = null;
    await SharedPrefsData1.setCurrentGamePlayListGrid3(_gameplayList);
    await SharedPrefsData1.setBoardTextsGrid3(_boardTexts);
    await SharedPrefsData1.setPlayerTurn(null);
    await SharedPrefsData1.setCurrentGameUserChoice(null);
    notifyListeners();
  }


  void resetGamePlay(BuildContext context) async {
    _count = 0;
    _userScore = 0;
    _compScore = 0;
    _hasCurrentGameSession = false;
    _playerTurn = null;
    _gameplayList = List<int?>.from(SharedPrefsData1.defaultGameplayListGrid3);
    _boardTexts = List<String?>.from(SharedPrefsData1.defaultBoardTextsGrid3);
    _currentGameUserChoice = null;
    _userScore = 0;
    _compScore = 0;
    await SharedPrefsData1.setCompScore(_compScore);
    await SharedPrefsData1.setUserScore(_userScore);
    await SharedPrefsData1.setCurrentGamePlayListGrid3(_gameplayList);
    await SharedPrefsData1.setBoardTextsGrid3(_boardTexts);
    await SharedPrefsData1.setPlayerTurn(null);
    await SharedPrefsData1.setCurrentGameUserChoice(null);
    notifyListeners();
    if(context.mounted){
      DeviceUtils.showFlushBar(context, "Succesfully reset game");
    }
  }


  void toggleUserChoice(BuildContext context) async {
    final String newChoice =
        (await SharedPrefsData1.getUserChoice()) == 'X' ? 'O' : 'X';
    await SharedPrefsData1.setUserChoice(newChoice);
    _userChoice = newChoice;
    notifyListeners();
    // ignore: use_build_context_synchronously
    DeviceUtils.showFlushBar(context, "You chose $newChoice");
  }

  void onWin(String win){
    if(win == ''){
      //Draw
    }else if(win == 'X'){
      //X won
    }else if(win == 'O'){
      //O won
    }

  }



}


