import 'package:background_fetch/background_fetch.dart';
import 'package:background_fetch/background_fetch.dart' as bf;
import 'package:flutter_offline_data_synching/background_services/task_constants.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager/workmanager.dart' as wm;

class TaskRegisters{

  static Future<void> updateUserOnceBF() async {

    await BackgroundFetch.scheduleTask(TaskConfig(
        taskId: TaskConstants.UserOneOffTaskBF,
        delay: 1000,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: false,
        enableHeadless: true,
    ));
  }

  static Future<void> updateRepoOnceBF() async {
    await BackgroundFetch.scheduleTask(TaskConfig(
        taskId: TaskConstants.RepoOneOffTaskBF,
        delay: 1000,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: false,
        enableHeadless: true,
    ));
  }

  static Future<void> updateUserPeriodicBF() async {
    await BackgroundFetch.scheduleTask(TaskConfig(
      taskId: TaskConstants.UserPeriodicTaskBF,
      delay: 1000,
      periodic: true,
      forceAlarmManager: false,
      stopOnTerminate: false,
      enableHeadless: true,
    ));
  }

  static Future<void> updateRepoPeriodicBF() async {
    await BackgroundFetch.scheduleTask(TaskConfig(
      taskId: TaskConstants.RepoPeriodicTaskBF,
      delay: 1000,
      periodic: true,
      forceAlarmManager: false,
      stopOnTerminate: false,
      enableHeadless: true
    ));
  }

  static Future<void> updateUserOnceWM() async {
    Workmanager().registerOneOffTask(TaskConstants.UserOneOffTaskWM,
        TaskConstants.UserOneOffTaskWM,
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }

  static Future<void> updateUserPeriodicWM() async {
    Workmanager().registerPeriodicTask(
        TaskConstants.UserPeriodicTaskWM,
        TaskConstants.UserPeriodicTaskWM,
        initialDelay: const Duration(milliseconds: 500),
        backoffPolicy: BackoffPolicy.linear,
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }

  static Future<void> updateRepoOnceWM() async {
    Workmanager().registerOneOffTask(TaskConstants.RepoOneOffTaskWM,
        TaskConstants.RepoOneOffTaskWM,
        initialDelay: const Duration(seconds: 2),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }

  static Future<void> updateRepoPeriodicWM() async {
    Workmanager().registerPeriodicTask(
        TaskConstants.RepoPeriodicTaskWM,
        TaskConstants.RepoPeriodicTaskWM,
        initialDelay: const Duration(milliseconds: 500),
        constraints: Constraints(
            networkType: wm.NetworkType.connected,
            requiresBatteryNotLow: true,
            requiresCharging: true,
            requiresDeviceIdle: true,
            requiresStorageNotLow: true
        ),
        backoffPolicy: BackoffPolicy.linear,
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }
}