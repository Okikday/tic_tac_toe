import 'package:tic_tac_toe/data/gameplay_data.dart';
import 'package:tic_tac_toe/services/game_provider.dart';

class Gameplay {

  int? checkWinner(listToCheck){
    final int count = GameProvider.count;
    final List gameplayedList = GameProvider.gameplayedList;
    int winCount = 0;

    if(count >= 4){

      for(var data in GameplayData.winningPatterns){ //the list in it
      for(int i = 0; i < 9; i++){
        if(data[i] == 0 && gameplayedList[i] == 0){
          winCount++;
        }
      }
    }
    if(winCount == 3){
      return 0;
    }
    winCount = 0;

    for(var data in GameplayData.winningPatterns){
      for(int i = 0; i < 9; i++){
        if(data[i] == 0 && gameplayedList[i] == 1){
          winCount++;
        }
      }
    }
    }

    if(winCount == 3){
      return 1;
    }
    return null;

  }

  
}