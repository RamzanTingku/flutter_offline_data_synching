import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/pref_manager/pref_manager.dart';
import 'package:flutter_offline_data_synching/data/remotedb/remote_data.dart';
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
    await Workmanager().initialize(callbackDispatcher);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    //get data
    await BoxInstances().initHive();
    var serverDataCount = await saveGithubRepoDataFromServer();

    //set count to pref
    int prefValue = await PrefManager.instance.getPrefData();
    await PrefManager.instance.savePrefData(prefValue+1);
    int updatedPrefValue = await PrefManager.instance.getPrefData();

    //show count to notification
    NotificationService()
        .showNotification(task, updatedPrefValue, serverDataCount.length);
    return Future.value(true);
  });
}