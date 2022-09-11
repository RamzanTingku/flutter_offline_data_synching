import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {

  static const String GithubRepoCount ='GithubRepoCount';
  static const String GithubUserCount ='GithubUserCount';

  PrefManager._privateConstructor();

  static final PrefManager _instance = PrefManager._privateConstructor();

  static PrefManager get instance => _instance;

  Future<bool> savePrefData(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  Future<int> getPrefData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counterValue = prefs.getInt(key) ?? 0;
    return counterValue;
  }
}