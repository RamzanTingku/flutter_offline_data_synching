import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_offline_data_synching/background_services/background_service.dart';

class BackgroundFetchService{
  BackgroundFetchService._privateConstructor();

  static final BackgroundFetchService _instance =
  BackgroundFetchService._privateConstructor();

  static BackgroundFetchService get instance => _instance;

  Future<void> init() async {
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

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  debugPrint("[BackgroundFetch] HEADLESS TASK: $taskId");
  if (timeout) {
    BackgroundFetch.finish(taskId);
    return;
  }
  await executeTask(taskId);
  BackgroundFetch.finish(taskId);
}

@pragma('vm:entry-point')
void backgroundFetchTask(String taskId) async {
  debugPrint("[BackgroundFetch] TASK: $taskId");
  await executeTask(taskId);
  BackgroundFetch.finish(taskId);
}

@pragma('vm:entry-point')
void backgroundFetchTimeout(String taskId) {
  debugPrint("[BackgroundFetch] TIMEOUT: $taskId");
  BackgroundFetch.finish(taskId);
}