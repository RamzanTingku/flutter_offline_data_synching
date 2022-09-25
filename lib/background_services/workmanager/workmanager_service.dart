import 'package:workmanager/workmanager.dart';

import '../background_service.dart';

class WorkmanagerService{
  WorkmanagerService._privateConstructor();

  static final WorkmanagerService _instance =
  WorkmanagerService._privateConstructor();

  static WorkmanagerService get instance => _instance;

  Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskId, inputData) async {
    if(!triggerFromMainIfActive(taskId)){
      await executeTask(taskId);
    }
    return Future.value(true);
  });
}