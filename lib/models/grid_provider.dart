import 'package:flutter/material.dart';

class GridProvider extends ChangeNotifier{
  String boxName;
  static List <int> scoreTrackingList = [];
  int count = 0;

  GridProvider({
    this.boxName = "3x3",
  });

  void updateScoreTrackingList(int pos, int value){
    scoreTrackingList.insert(pos-1, value);
    count++;
    //notifyListeners();
  }

  void checkWinning(){
    
    for(int i = 0; i < scoreTrackingList.length; i++){

    }
  }

  sayHello(){
    debugPrint("Hello!");
  }

}