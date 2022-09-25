import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_offline_data_synching/background_services/task_registors.dart';
import 'package:flutter_offline_data_synching/backgroundfetch_example.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubuserbox.dart';
import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:flutter_offline_data_synching/data/pref_manager/pref_manager.dart';
import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
import 'package:flutter_offline_data_synching/workmanager_example.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_services/background_service.dart';
import 'data/localdb/githubuserbox.dart';

const String TAG = "BackGround_Work";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await BoxInstances().initHive();
  await BackgroundService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BackGround Work Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BackGroundWorkSample(),
    );
  }
}

class BackGroundWorkSample extends StatefulWidget {
  const BackGroundWorkSample({Key? key}) : super(key: key);

  @override
  _BackGroundWorkSampleState createState() => _BackGroundWorkSampleState();
}

class _BackGroundWorkSampleState extends State<BackGroundWorkSample> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Background Offline Data Synching'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Expanded(child: WorkmanagerExample()),
              Expanded(child: BackgroundFetchExample())
            ],
          ),
        ));
  }
}