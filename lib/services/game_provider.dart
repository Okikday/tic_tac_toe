import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
import 'package:tic_tac_toe/models/generate_play.dart';
import 'package:tic_tac_toe/services/device_provider.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';

class GameProvider extends ChangeNotifier {

  int _count = 0;
  List<int?> _gameplayList = List<int?>.from(SharedPrefsData1.defaultGameplayList);
  List<String?> _boardTexts = List<String?>.from(SharedPrefsData1.defaultBoardTexts);
  String _userChoice = 'X';
  int _userScore = 0;
  int _compScore = 0;
  bool _hasCurrentGameSession = false;

  // Getters
  List<String?> get boardTexts => _boardTexts;
  int get count => _count;
  String get userChoice => _userChoice;
  int get userScore => _userScore;
  int get compScore => _compScore;
  bool get hasCurrentGameSession => _hasCurrentGameSession;

  Future<void> initGameProvider() async{
    _gameplayList = await SharedPrefsData1.getCurrentGamePlayList();
    _boardTexts = await SharedPrefsData1.getBoardTexts();
    _userChoice = await SharedPrefsData1.getUserChoice();
    _userScore = await SharedPrefsData1.getUserScore();
    _compScore = await SharedPrefsData1.getCompScore();

    for (var item in _gameplayList) {
      item != null ? _count++ : (){};
    }
    _hasCurrentGameSession = _count > 0;
    notifyListeners();
    print("Successfully initialized Game Provider");
  }

//   Future<void> initGameplayData() async {
    
//     notifyListeners();

//     // if (!_userFirst) {
//     //   playGame(); // Computer plays first if the board is not empty
//     // }
//   }



//   void calcWhoPlaysFirst(BuildContext context, int pos){

//     String userchoice = Provider.of<DeviceProvider>(context, listen: false).userChoice;

//     if(count % 2 == 0 && userchoice == 'X'){
//       _userFirst = true;
//       userPlay(pos);
//     }else if(count % 2 == 1 && userchoice == 'X'){
//       _userFirst = false;
//       compPlay(GeneratePlayGridThree().easyMove(_gameplayList));
//     }else if(count % 2 == 0 && userchoice == 'O'){
//       _userFirst = false;
//       compPlay(GeneratePlayGridThree().easyMove(_gameplayList));
//     }else if(count % 2 == 1 && userchoice == 'O'){
//       userPlay(pos);
//     }

//   }

//   void playGame(BuildContext context, {int pos = -1}) async {
//     calcWhoPlaysFirst(context, pos);

//     if(_userFirst == true){
//       _userFirst = false;
//       compPlay(GeneratePlayGridThree().easyMove(_gameplayList));
//     }

   
//   }

//   void userPlay(int pos) async {
//     if (_gameplayList[pos] == null) {
//       _updateGame(pos);
//     }
//   }

//   void compPlay(int pos) async {
//     if (_gameplayList[pos] == null) {
//       _updateGame(pos);
//     }
//   }

//   void _updateGame(int pos) async {
//     // _gameplayList[pos] = _currentValue == 'X' ? 1 : 0;
//     // _boardTexts[pos] = _currentValue;
//     // _count++;
//     // await SharedPrefsData1.setCurrentGamePlayList(_gameplayList);
//     // await SharedPrefsData1.setBoardTexts(_boardTexts);
//     // checkGameplay();
//   }

//   void checkGameplay() {
//     // Implement logic to check for a win or a draw and update accordingly
//   }

  void resetGamePlay() async {
    _count = 0;
    _userScore = 0;
    _compScore = 0;
    _hasCurrentGameSession = false;
    _gameplayList = List<int?>.from(SharedPrefsData1.defaultGameplayList);
    _boardTexts = List<String?>.from(SharedPrefsData1.defaultBoardTexts);
    await SharedPrefsData1.setCurrentGamePlayList(_gameplayList);
    await SharedPrefsData1.setBoardTexts(_boardTexts);
    notifyListeners();
    print("Reset Gameplay");
  }

  void toggleUserChoice(BuildContext context) async {
    final String newChoice = (await SharedPrefsData1.getUserChoice()) == 'X' ? 'O' : 'X';
    await SharedPrefsData1.setUserChoice(newChoice);
    _userChoice = newChoice;
    notifyListeners();
    // ignore: use_build_context_synchronously
    DeviceUtils.showFlushBar(context, "You chose $newChoice");

  }

//   void onWin(String win){
//     if(win == ''){
//       //Draw
//     }else if(win == 'X'){
//       //X won
//     }else if(win == 'O'){
//       //O won
//     }

//   }

}
