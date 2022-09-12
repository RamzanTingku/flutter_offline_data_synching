import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  get onDidReceiveLocalNotification => null;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails("offline_syncer", "Offline Syncer",
          importance: Importance.high, priority: Priority.high);

  static const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails();

  Future selectNotification(String? payload) async {
    return log("PAYLOAD: $payload");
  }

  Future showNotification(String workmanagerType, int prefValue, int serverValue) async {
    return await flutterLocalNotificationsPlugin.show(
        0,
        "Notification from $workmanagerType",
        "Pref value: $prefValue   ServerData length: $serverValue",
        platformChannelSpecifics);
  }
}
