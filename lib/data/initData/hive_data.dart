import 'package:hive_flutter/hive_flutter.dart';

class HiveData {
  static late Box box;
  static Future<void> initHiveData() async{
    box = await Hive.openBox("myBox");
  }
}