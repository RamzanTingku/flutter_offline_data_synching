import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_offline_data_synching/background_services/task_constants.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/pref_manager/pref_manager.dart';
import 'package:flutter_offline_data_synching/data/remotedb/remote_data.dart';
import 'package:flutter_offline_data_synching/data/repository/repository.dart';
import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
import 'package:flutter_offline_data_synching/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:background_fetch/background_fetch.dart' as network;

class BackgroundService {
  BackgroundService._privateConstructor();

  static final BackgroundService _instance =
      BackgroundService._privateConstructor();

  static BackgroundService get instance => _instance;

  Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        forceAlarmManager: false,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
    ), backgroundFetchTask, backgroundFetchTimeout);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await executeTask(task);
    return Future.value(true);
  });
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    BackgroundFetch.finish(taskId);
    return;
  }
  await executeTask(taskId);
  BackgroundFetch.finish(taskId);
}

void backgroundFetchTask(String taskId) async {
  await executeTask(taskId);
  BackgroundFetch.finish(taskId);
}

void backgroundFetchTimeout(String taskId) {
  print("[BackgroundFetch] TIMEOUT: $taskId");
  BackgroundFetch.finish(taskId);
}

Future<void> executeTask(String taskId) async {
  await BoxInstances().initHive();
  int updatedPrefValue = 0, serverDataCount = 0;
  switch (taskId) {
    case TaskConstants.RepoOneOffTaskWM:
    case TaskConstants.RepoPeriodicTaskWM:
    case TaskConstants.RepoOneOffTaskBF:
    case TaskConstants.RepoPeriodicTaskBF:
      serverDataCount = getSavedDataCount(await Repository().getGithubRepos());
      updatedPrefValue = await getPrefDataCount(PrefManager.GithubRepoCount);
      break;
    case TaskConstants.UserOneOffTaskWM:
    case TaskConstants.UserPeriodicTaskWM:
    case TaskConstants.UserOneOffTaskBF:
    case TaskConstants.UserPeriodicTaskBF:
      serverDataCount = getSavedDataCount(await Repository().getGithubUser());
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
