import 'package:tic_tac_toe/data/initData/hive_data.dart';

class Data {

  static var data = HiveData.box;

  static void setUserData(Map<String, dynamic> userData) => data.put('userData', userData);

  static Map<String, dynamic>? getUserData() {
  final Map<dynamic, dynamic>? userData = data.get('userData');
  
  if (userData == null) {
    return null;
  }

  // Create a new map with String keys and the same values
  final Map<String, dynamic> stringKeyedMap = {};

  userData.forEach((key, value) {
    stringKeyedMap[key.toString()] = value;
  });

  return stringKeyedMap;
}



  
}