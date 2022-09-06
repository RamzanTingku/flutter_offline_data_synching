import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  BackgroundService._privateConstructor();
  static final BackgroundService _instance =
      BackgroundService._privateConstructor();
  static BackgroundService get instance => _instance;

  Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      int value = await BackGroundWork.instance.getBackGroundCounterValue();
      int updatedValue = value + 1;
      BackGroundWork.instance.loadCounterValue(updatedValue);
      NotificationService()
          .showNotification(updatedValue, updatedValue.toString());
      return Future.value(true);
    });
  }
}

class BackGroundWork {
  BackGroundWork._privateConstructor();

  static final BackGroundWork _instance = BackGroundWork._privateConstructor();

  static BackGroundWork get instance => _instance;

  loadCounterValue(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('BackGroundCounterValue', value);
  }

  Future<int> getBackGroundCounterValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    int counterValue = prefs.getInt('BackGroundCounterValue') ?? 0;
    return counterValue;
  }
}
