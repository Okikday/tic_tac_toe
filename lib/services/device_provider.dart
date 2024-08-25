import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';

class DeviceProvider extends ChangeNotifier {
  String userChoice;
  int gridType;
  String challengeType;
  int userScore;
  int compScore;

  DeviceProvider({
    this.userChoice = "lol",
    this.gridType = SharedPrefsData1.defaultGridType,
    this.challengeType = SharedPrefsData1.defaultChallengeType,
    this.userScore = SharedPrefsData1.defaultUserScore,
    this.compScore = SharedPrefsData1.defaultCompScore,
  });

  Future<void> initDeviceProvider() async {
    userChoice = await SharedPrefsData1.getUserChoice();
    gridType = await SharedPrefsData1.getGridType();
    challengeType = await SharedPrefsData1.getChallengeType();
    userScore = await SharedPrefsData1.getUserScore();
    compScore = await SharedPrefsData1.getCompScore();
    notifyListeners();
  }

  void toggleUserChoice() async {
    final String newChoice = (await SharedPrefsData1.getUserChoice()) == 'X' ? 'O' : 'X';
    await SharedPrefsData1.setUserChoice(newChoice);
    userChoice = await SharedPrefsData1.getUserChoice();
    notifyListeners();
    Fluttertoast.showToast(msg: "You are now playing as $userChoice");
  }

}
