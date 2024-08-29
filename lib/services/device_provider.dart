import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';

class DeviceProvider extends ChangeNotifier {
  int _gridType = SharedPrefsData1.defaultGridType;
  String _challengeType = SharedPrefsData1.defaultChallengeType;

  int get gridType => _gridType;
  String get challengeType => _challengeType;
  Future<void> initDeviceProvider() async{
    _gridType = await SharedPrefsData1.getGridType();
    _challengeType = await SharedPrefsData1.getChallengeType();
  }
  

  void changeGridType({bool? toGrid3}) async{
    if(toGrid3 == true){
      _gridType = 3;
      await SharedPrefsData1.setGridType(_gridType);
    }
    if(toGrid3 == false){
      _gridType = 4;
      await SharedPrefsData1.setGridType(_gridType);
    }
  }

  void changeChallengeType({String? changeTo}) async{
    if(changeTo == 'E'){
      _challengeType = 'E';
      await SharedPrefsData1.setChallengeType(_challengeType);
    }
    if(changeTo == 'M'){
      _challengeType = 'M';
      await SharedPrefsData1.setChallengeType(_challengeType);
    }
    if(changeTo == 'H'){
      _challengeType = 'H';
      await SharedPrefsData1.setChallengeType(_challengeType);
    }
  }

  

  

}
