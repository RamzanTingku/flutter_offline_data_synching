import 'dart:isolate';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_offline_data_synching/background_services/backgroundfetch/backgroundfetch_service.dart';
import 'package:flutter_offline_data_synching/background_services/task_constants.dart';
import 'package:flutter_offline_data_synching/background_services/workmanager/workmanager_service.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/pref_manager/pref_manager.dart';
import 'package:flutter_offline_data_synching/data/repository/repository.dart';
import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  BackgroundService._privateConstructor();

  static final BackgroundService _instance =
      BackgroundService._privateConstructor();

  static BackgroundService get instance => _instance;

  Future<void> init() async {
    await WorkmanagerService.instance.init();
    await BackgroundFetchService.instance.init();
    await initReceiverPortForOtherIsolates();
  }
}

@pragma('vm:entry-point')
Future<void> initReceiverPortForOtherIsolates() async{
  var port = ReceivePort();
  if (IsolateNameServer.lookupPortByName('bChannel') != null) {
    IsolateNameServer.removePortNameMapping('bChannel');
  }
  IsolateNameServer.registerPortWithName(port.sendPort, 'bChannel');
  port.listen((dynamic taskId) async {
    debugPrint('[Main][bChannel listener] got $taskId');
    await executeTask(taskId);
  });
}

@pragma('vm:entry-point')
bool triggerFromMainIfActive(String taskId) {
  var sendPort = IsolateNameServer.lookupPortByName('bChannel');
  if (sendPort != null) {
    sendPort.send(taskId);
    debugPrint("[Background] message $taskId sent.");
    return true;
  }
  return false;
}

@pragma('vm:entry-point')
Future<void> executeTask(String taskId) async {
  await BoxInstances().initHive();
  int updatedPrefValue = 0, serverDataCount = 0;
  switch (taskId) {
    case TaskConstants.RepoOneOffTaskWM:
    case TaskConstants.RepoPeriodicTaskWM:
    /*case TaskConstants.RepoOneOffTaskBF:
    case TaskConstants.RepoPeriodicTaskBF:*/
      serverDataCount = getSavedDataCount(await Repository().getGithubRepos(taskId));
      updatedPrefValue = await getPrefDataCount(PrefManager.GithubRepoCount);
      break;
    /*case TaskConstants.UserOneOffTaskWM:
    case TaskConstants.UserPeriodicTaskWM:*/
    case TaskConstants.UserOneOffTaskBF:
    case TaskConstants.UserPeriodicTaskBF:
    case TaskConstants.flutter_background_fetch:
      serverDataCount = getSavedDataCount(await Repository().getGithubUser(taskId));
      updatedPrefValue = await getPrefDataCount(PrefManager.GithubUserCount);
      break;
    case Workmanager.iOSBackgroundTask:
      print("The iOS background fetch was triggered");
      break;
  }

  //show count to notification
  NotificationService()
      .showNotification(taskId, updatedPrefValue, serverDataCount);
}

Future<int> getPrefDataCount(String key) async {
  int prefValue = await PrefManager.instance.getPrefData(key);
  await PrefManager.instance.savePrefData(key, prefValue + 1);
  return await PrefManager.instance.getPrefData(key);
}

int getSavedDataCount<T>(List<T> list) {
  return list.length;
}
