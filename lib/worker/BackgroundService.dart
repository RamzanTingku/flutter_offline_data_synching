import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/remotedb/repository.dart';
import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
import 'package:flutter_offline_data_synching/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  BackgroundService._privateConstructor();
  static final BackgroundService _instance =
      BackgroundService._privateConstructor();
  static BackgroundService get instance => _instance;

  Future<void> init() async {
    await Workmanager().cancelAll();
    await Workmanager().initialize(callbackDispatcher);
  }
}

class BackGroundWork {
  BackGroundWork._privateConstructor();

  static final BackGroundWork _instance = BackGroundWork._privateConstructor();

  static BackGroundWork get instance => _instance;

  Future<bool> savePrefData(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt('BackGroundCounterValue', value);
  }

  Future<int> getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    int counterValue = prefs.getInt('BackGroundCounterValue') ?? 0;
    return counterValue;
  }
}
