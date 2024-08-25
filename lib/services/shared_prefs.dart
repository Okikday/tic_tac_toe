import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  
  static late SharedPreferences preferences;
  static Future<void> initPrefs () async{
    preferences = await SharedPreferences.getInstance();

  }

}


