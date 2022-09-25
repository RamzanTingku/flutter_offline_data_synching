import 'package:flutter_offline_data_synching/background_services/task_registor_helper.dart';
import 'package:flutter_offline_data_synching/background_services/task_registors.dart';
import 'package:workmanager/workmanager.dart';

class WMTaskRegisters extends TaskRegisterHelper {
  @override
  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }

  @override
  Future<void> cancelByTask(String taskName) async {
    await Workmanager().cancelByUniqueName(taskName);
  }

  @override
  Future<void> triggerOnce(String taskId, int initialDelay,
      [bool enableOnAppTerminate = true,
      bool requiresNetworkConnectivity = false,
      bool requiresStorageNotLow = false]) async {

    await Workmanager().registerOneOffTask(taskId,
        taskId,
        initialDelay: Duration(milliseconds: initialDelay),
        constraints: Constraints(
            networkType: requiresNetworkConnectivity
                ? NetworkType.connected
                : NetworkType.not_required,
            requiresStorageNotLow: requiresStorageNotLow),
        existingWorkPolicy: ExistingWorkPolicy.replace);
  }

  @override
  Future<void> triggerPeriodic(String taskId, int initialDelay,
      [int frequency = 15,
      bool enableOnAppTerminate = true,
      bool requiresNetworkConnectivity = false,
      bool requiresStorageNotLow = false]) async {

    await Workmanager().registerPeriodicTask(
      taskId,
      taskId,
      initialDelay: Duration(milliseconds: initialDelay),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
          networkType: requiresNetworkConnectivity
              ? NetworkType.connected
              : NetworkType.not_required,
          requiresStorageNotLow: requiresStorageNotLow),
    );

  }
}
