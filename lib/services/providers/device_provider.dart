import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/data.dart';
import 'package:tic_tac_toe/data/shared_prefs_data_1.dart';
class DeviceProvider extends ChangeNotifier {
  int _gridType = SharedPrefsData1.defaultGridType;
  String _challengeType = SharedPrefsData1.defaultChallengeType;
  String _userId = '';
  String _userName = '';
  String _userEmail = '';
  bool _isUserLoggedIn = false;
  bool _hasUserData = false;
  String _photoURL = "";
  bool _hasCurrentOnlineGameSession = false;
  int get gridType => _gridType;
  String get challengeType => _challengeType;
  String get userId => _userId;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isUserLoggedIn => _isUserLoggedIn;
  bool get hasUserData => _hasUserData;
  String get photoURL => _photoURL;
  bool get hasCurrentOnlineGameSession => _hasCurrentOnlineGameSession;

  Future<void> initDeviceProvider() async{
    _gridType = await SharedPrefsData1.getGridType();
    _challengeType = await SharedPrefsData1.getChallengeType();
    //userLoggedIn, userId, userName, 
    final Map<String, dynamic> userDataMap = Data.getUserData() ?? {};
    _hasUserData = userDataMap.isEmpty ? false : true;
    if(_hasUserData == true){
      _isUserLoggedIn = userDataMap["userLoggedIn"];
      _userId = userDataMap["userId"];
      _userName = userDataMap["userName"];
      _userEmail = userDataMap["email"];
      _photoURL = userDataMap["photoURL"];
    }else{
      _isUserLoggedIn = false;
    }
    _hasCurrentOnlineGameSession = false;
  }
  

  void changeGridType({int? toGrid}) async{
    if(toGrid == 3){
      _gridType = 3;
      await SharedPrefsData1.setGridType(_gridType);
    }
    if(toGrid == 4){
      _gridType = 4;
      await SharedPrefsData1.setGridType(_gridType);
    }
    if(toGrid == 5){
      _gridType = 5;
      await SharedPrefsData1.setGridType(_gridType);
    }
    if(toGrid == null){
      _gridType = 3;
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

  void saveUserDetails(String name, String email, String id, String photo) async{
    _userId = id;
    _userName = name;
    _userEmail = email;
    _isUserLoggedIn = true;
    _photoURL = photo;
    Data.setUserData({
      'userId' : _userId,
      'email' : _userEmail,
      'userName' : _userName,
      'userLoggedIn' : _isUserLoggedIn,
      'photoURL': _photoURL
    });
  }

  void resetUserDetails(){
    _userId = '';
    _userName = '';
    _userEmail = '';
    _isUserLoggedIn = false;
    _photoURL = '';
    _hasCurrentOnlineGameSession = false;
    Data.setUserData({
      'userId' : _userId,
      'email' : _userEmail,
      'userName' : _userName,
      'userLoggedIn' : _isUserLoggedIn,
      'photoURL' : _photoURL,
    });
  }

  void setCurrentHasOnlineGameSession(bool hasGameSession){
    _hasCurrentOnlineGameSession = hasGameSession;
  }

  void endCurrentHasOnlineGameSession(){
    _hasCurrentOnlineGameSession = false;
  }
  

}
