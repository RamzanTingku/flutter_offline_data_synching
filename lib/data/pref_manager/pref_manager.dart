import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {

  static const String BackGroundCounterValue ='BackGroundCounterValue';

  PrefManager._privateConstructor();

  static final PrefManager _instance = PrefManager._privateConstructor();

  static PrefManager get instance => _instance;

  Future<bool> savePrefData(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(BackGroundCounterValue, value);
  }

  Future<int> getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    int counterValue = prefs.getInt(BackGroundCounterValue) ?? 0;
    return counterValue;
  }
}