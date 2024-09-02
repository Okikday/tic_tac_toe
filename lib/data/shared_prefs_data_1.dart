import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/data/initData/shared_prefs.dart';

class SharedPrefsData1 {

  static SharedPreferences preferences = SharedPrefs.preferences;

  // Default Data
  static const String defaultUserChoice = 'X'; 
  static const int defaultGridType = 3; 
  static const String defaultChallengeType = "E"; //E for Easy, M for Medium, H for Hard
  static const int defaultUserScore = 0;
  static const int defaultCompScore = 0;
  static const List<int?> defaultGameplayListGrid3 = [null, null, null, null, null, null, null, null, null];
  static const List<String?> defaultBoardTextsGrid3 = [null, null, null, null, null, null, null, null, null];
  static const List<int?> defaultGameplayListGrid4 = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null];
  static const List<String?> defaultBoardTextsGrid4 = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null];
  static const List<int?> defaultGameplayListGrid5 = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null];
  static const List<String?> defaultBoardTextsGrid5 = [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null];
  

  static Future<void> initializeAndLoadPreferences() async {
    // Initialize and load preferences
    if (preferences.getString("userChoice") == null) {
      await setUserChoice(defaultUserChoice);
    }
    if (preferences.getInt("gridType") == null) {
      await setGridType(defaultGridType);
    }
    if (preferences.getString("challengeType") == null) {
      await setChallengeType(defaultChallengeType);
    }
    if (preferences.getInt("userScore") == null) {
      await setUserScore(defaultUserScore);
    }
    if (preferences.getInt("compScore") == null) {
      await setCompScore(defaultCompScore);
    }
    if(preferences.getStringList("boardTextsGrid3") == null || preferences.getStringList("boardTextsGrid3")!.isEmpty){
      await setBoardTextsGrid3(defaultBoardTextsGrid3);
    }

    debugPrint("Successfully initialized and loaded preferences");
  }

  static Future<void> setUserChoice(String value) async => await preferences.setString("userChoice", value);

  static Future<String> getUserChoice() async => preferences.getString("userChoice") ?? defaultUserChoice;

  static Future<void> setGridType(int value) async => await preferences.setInt("gridType", value);

  static Future<int> getGridType() async => preferences.getInt("gridType") ?? defaultGridType;

  static Future<void> setChallengeType(String value) async => await preferences.setString("challengeType", value);

  static Future<String> getChallengeType() async => preferences.getString("challengeType") ?? defaultChallengeType;

  static Future<void> setUserScore(int value) async => await preferences.setInt("userScore", value);

  static Future<int> getUserScore() async => preferences.getInt("userScore") ?? defaultUserScore;

  static Future<void> setCompScore(int value) async => await preferences.setInt("compScore", value);

  static Future<int> getCompScore() async => preferences.getInt("compScore") ?? defaultCompScore;

  static Future<void> setPlayerTurn(int? value) async {
    if(value == null){
      await preferences.remove("playerTurn");
    }else{
      await preferences.setInt("playerTurn", value);
    }
  }

  static Future<int?> getPlayerTurn() async => preferences.getInt("playerTurn");

  static Future<void> setCurrentGameUserChoice(String? value) async {
    if(value == null){
      await preferences.remove("currentGameUserChoice");
    }else{
      await preferences.setString("currentGameUserChoice", value);
    }
  }

  static Future<String?> getCurrentGameUserChoice() async => preferences.getString("currentGameUserChoice");
  

  static Future<void> setBoardTextsGrid3(List<String?> value) async {
    List<String> newBoardTexts = [];
    for (var item in value) {
      newBoardTexts.add(item ?? "null");
    }
    await preferences.setStringList("boardTextsGrid3", newBoardTexts);
  }

  static Future<void> setBoardTextsGrid4(List<String?> value) async {
    List<String> newBoardTexts = [];
    for (var item in value) {
      newBoardTexts.add(item ?? "null");
    }
    await preferences.setStringList("boardTextsGrid4", newBoardTexts);
  }

  static Future<void> setBoardTextsGrid5(List<String?> value) async {
    List<String> newBoardTexts = [];
    for (var item in value) {
      newBoardTexts.add(item ?? "null");
    }
    await preferences.setStringList("boardTextsGrid5", newBoardTexts);
  }

  static Future<List<String?>> getBoardTextsGrid3() async => preferences.getStringList("boardTextsGrid3") ?? defaultBoardTextsGrid3;

  static Future<List<String?>> getBoardTextsGrid4() async => preferences.getStringList("boardTextsGrid4") ?? defaultBoardTextsGrid4;

  static Future<List<String?>> getBoardTextsGrid5() async => preferences.getStringList("boardTextsGrid5") ?? defaultBoardTextsGrid5;

  static Future<List<int?>> getCurrentGamePlayListGrid3() async {
    final List<String> defaultList = [];
    // ignore: unused_local_variable
    for (var item in defaultGameplayListGrid3) {
      defaultList.add("null");
    }
    List<String>? listAsString = preferences.getStringList("currentGameplayListGrid3") ?? defaultList;
    final List<int?> list = [];
    for (var item in listAsString) {
      list.add(item == "null" ? null : int.parse(item));
    }
    return list;
  }

  static Future<List<int?>> getCurrentGamePlayListGrid4() async {
    final List<String> defaultList = [];
    // ignore: unused_local_variable
    for (var item in defaultGameplayListGrid4) {
      defaultList.add("null");
    }
    List<String>? listAsString = preferences.getStringList("currentGameplayListGrid4") ?? defaultList;
    final List<int?> list = [];
    for (var item in listAsString) {
      list.add(item == "null" ? null : int.parse(item));
    }
    return list;
  }

  static Future<List<int?>> getCurrentGamePlayListGrid5() async {
    final List<String> defaultList = [];
    // ignore: unused_local_variable
    for (var item in defaultGameplayListGrid5) {
      defaultList.add("null");
    }
    List<String>? listAsString = preferences.getStringList("currentGameplayListGrid5") ?? defaultList;
    final List<int?> list = [];
    for (var item in listAsString) {
      list.add(item == "null" ? null : int.parse(item));
    }
    return list;
  }

  static Future<void> setCurrentGamePlayListGrid3(List<int?> value) async{
    final List<String> list = [];
    for (var item in value) {
      list.add(item == null ? "null" : item.toString());
    }
    preferences.setStringList("currentGameplayListGrid3", list);
  }

  static Future<void> setCurrentGamePlayListGrid4(List<int?> value) async{
    final List<String> list = [];
    for (var item in value) {
      list.add(item == null ? "null" : item.toString());
    }
    preferences.setStringList("currentGameplayListGrid4", list);
  }

  static Future<void> setCurrentGamePlayListGrid5(List<int?> value) async{
    final List<String> list = [];
    for (var item in value) {
      list.add(item == null ? "null" : item.toString());
    }
    preferences.setStringList("currentGameplayListGrid5", list);
  }
  
}
