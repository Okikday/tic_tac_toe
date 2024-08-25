import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier{

  static List <int?> gameplayedList = List.generate(9, (item) => null);
  //for example: [0, null, 1, 0, 1, null, null, 1, 0]
  static int count = 0;
  static String startWith = 'X';

  void initGameplay(){
    
  }

  void updategameplayedList(int pos, int value){
    gameplayedList.insert(pos-1, value);
    count++;
    notifyListeners();
  }

  

}