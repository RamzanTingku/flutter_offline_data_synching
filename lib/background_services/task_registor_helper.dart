abstract class TaskRegisterHelper {
  ///frequency is in minutes
  ///initialDelay is in milliseconds

  Future<void> triggerOnce(String taskId, int initialDelay,
      [bool enableOnAppTerminate = true,
      bool requiresNetworkConnectivity = false,
      bool requiresStorageNotLow = false]);


  Future<void> triggerPeriodic(String taskId, int initialDelay,
      [int frequency = 15,
      bool enableOnAppTerminate = true,
      bool requiresNetworkConnectivity = false,
      bool requiresStorageNotLow = false]);

  Future<void> cancelByTask(String taskName);

  Future<void> cancelAll();
}
