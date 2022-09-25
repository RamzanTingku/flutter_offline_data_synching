import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_offline_data_synching/background_services/task_registor_helper.dart';

import '../task_constants.dart';

class BfTaskRegisters extends TaskRegisterHelper {
  @override
  Future<void> triggerPeriodic(String taskId, int initialDelay,
      [int frequency = 15,
      bool enableOnAppTerminate = true,
      bool requiresNetworkConnectivity = false,
      requiresStorageNotLow = false]) async {
    /// frequency is set on background fetch initializations
    await BackgroundFetch.scheduleTask(TaskConfig(
        taskId: taskId,
        delay: initialDelay,
        periodic: true,
        forceAlarmManager: false,
        stopOnTerminate: !enableOnAppTerminate,
        enableHeadless: enableOnAppTerminate,
        requiresNetworkConnectivity: requiresNetworkConnectivity,
        requiresStorageNotLow: requiresStorageNotLow));
  }


  @override
  Future<void> triggerOnce(String taskId, int initialDelay,
      [bool enableOnAppTerminate = true,
      bool requiresNetworkConnectivity = false,
      bool requiresStorageNotLow = false]) async {

    await BackgroundFetch.scheduleTask(TaskConfig(
        taskId: taskId,
        delay: initialDelay,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: !enableOnAppTerminate,
        enableHeadless: enableOnAppTerminate,
        requiresNetworkConnectivity: requiresNetworkConnectivity,
        requiresStorageNotLow: requiresStorageNotLow));
  }

  @override
  Future<void> cancelByTask(String taskName) async {
    await BackgroundFetch.stop(taskName);
  }

  @override
  Future<void> cancelAll() async {
    await BackgroundFetch.stop();
  }
}
