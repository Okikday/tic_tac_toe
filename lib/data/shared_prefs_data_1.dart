import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe/services/shared_prefs.dart';

class SharedPrefsData1 {

  static SharedPreferences preferences = SharedPrefs.preferences;

  // Default Data
  static const String defaultUserChoice = 'X'; 
  static const int defaultGridType = 3; 
  static const String defaultChallengeType = "normal";
  static const int defaultUserScore = 0;
  static const int defaultCompScore = 0;

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
}
