import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubuserbox.dart';
import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:flutter_offline_data_synching/data/pref_manager/pref_manager.dart';
import 'package:flutter_offline_data_synching/data/remotedb/remote_data.dart';
import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

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

Future<List<GithubRepos>> saveGithubRepoDataFromServer() async {
  var repos = await RemoteData.getGithubRepos();
  await GithubRepoBox().add(repos);
  return await GithubRepoBox().getAllData();
}

Future<List<GithubUser>> saveGithubUserDataFromServer() async {
  var user = await RemoteData.getGithubUser();
  await GithubUserBox().add(user);
  return await GithubUserBox().getAllData();
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
  List<GithubRepos> _serverData = [];
  int _prefValue = 0;
  late StreamSubscription _loginSubscription;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _prefValue = await PrefManager.instance.getPrefData();
    _serverData = await GithubRepoBox().getAllData();
    setState(() {});
  }

  Future<void> triggerOneOffTask() async {
    Workmanager().registerOneOffTask("simpleOneOffTask", "simpleOneOffTask",
        existingWorkPolicy: ExistingWorkPolicy.append);
  }

  Future<void> triggerPeriodicTask() async {
    Workmanager().registerPeriodicTask("simplePeriodicTask", "simplePeriodicTask",
        initialDelay: const Duration(milliseconds: 500),
        backoffPolicy: BackoffPolicy.linear,
        existingWorkPolicy: ExistingWorkPolicy.append);
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Background Offline Data Synching'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await loadData();
                    },
                    child: const SizedBox(width: double.infinity, child: Text("Refresh", textAlign: TextAlign.center,)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await triggerOneOffTask();
                    },
                    child: const SizedBox(width: double.infinity, child: Text("Update Data From OneOff WM",textAlign: TextAlign.center)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await triggerPeriodicTask();
                    },
                    child: const SizedBox(width: double.infinity, child: Text("Update Data From Periodic WM",textAlign: TextAlign.center)),
                  ),
                  Text("Pref value: $_prefValue   ServerData length: ${_serverData.length}",),
                  buildContent(_serverData)
                  /*ValueListenableBuilder<Box<GithubRepos>>(
                    valueListenable: BoxInstances().githubRepoBox!.listenable(),
                    builder: (context, box, _) {
                      final storages = box.values.toList().cast<GithubRepos>();
                      return buildContent(storages);
                    },
                  ),*/
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildContent(List<GithubRepos> storages) {
    List<Widget> textListView = [];
    for(int i=0; i<storages.length;i++){
      textListView.add(Text("${storages[i].items?[i].timeStamp}"));
    }
    return Column(
     children: textListView,
    );
  }
}