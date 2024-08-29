import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/gameplay_data.dart';

class Gameplay {

  int? checkWinnerGrid3(List<int?> listToCheck, int count) {
    
    // Ensure there are enough moves to determine a winner
    if (count < 5) {
      return null; // Not enough moves for a winner
    }

    int counter = 0;
    debugPrint("Checkwinner: count: $count");

    // Checking for 0 which stands for O
    for (var pattern in GameplayData.winningPatternsGrid3) {
      counter = 0;
      for(int i = 0; i < listToCheck.length; i++){
        if(pattern[i] == 0 && listToCheck[i] == 0){
          counter++;
        }
        if(counter == 3){
          return 0;
        }
      }
    }

    counter = 0;

    for (var pattern in GameplayData.winningPatternsGrid3) {
      counter = 0;
      for(int i = 0; i < listToCheck.length; i++){
        if(pattern[i] == 0 && listToCheck[i] == 1){
          counter++;
        }
        if(counter == 3){
          return 1;
        }
      }
    }

    return null; // No winner
  }

  int? checkWinnerGrid4(List<int?> listToCheck, int count) {
  // Ensure there are enough moves to determine a winner
  if (count < 7) { // Minimum 7 moves required for a winner in a 4x4 grid
    return null;
  }

  // Checking for 0 which stands for O
  for (var pattern in GameplayData.winningPatternsGrid4) {
    if (pattern.every((index) => listToCheck[index] == 0)) {
      return 0; // O wins
    }
  }

  // Checking for 1 which stands for X
  for (var pattern in GameplayData.winningPatternsGrid4) {
    if (pattern.every((index) => listToCheck[index] == 1)) {
      return 1; // X wins
    }
  }

  return null; // No winner
}




}
