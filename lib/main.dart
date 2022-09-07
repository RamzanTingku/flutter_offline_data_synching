import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubuserbox.dart';
import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:flutter_offline_data_synching/data/remotedb/repository.dart';
import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
import 'package:flutter_offline_data_synching/worker/BackgroundService.dart';
import 'package:workmanager/workmanager.dart';

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
  var repos = await Repository.getGithubRepos();
  await GithubRepoBox().add(repos);
  return await GithubRepoBox().getAllData();
}

Future<List<GithubUser>> saveGithubUserDataFromServer() async {
  var user = await Repository.getGithubUser();
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
  int _serverValue = 0;
  int _prefValue = 0;
  late StreamSubscription _loginSubscription;

  @override
  void initState() {
    super.initState();
    Workmanager().registerPeriodicTask(TAG, "simplePeriodicTask",
        initialDelay: const Duration(seconds: 1),
        existingWorkPolicy: ExistingWorkPolicy.append);
    loadData();
  }

  void loadData() async {
    _prefValue = await BackGroundWork.instance.getPrefData();
    _serverValue = await GithubUserBox().getAllData().then((value) => value.length);
    setState(() {});
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
          title: const Text('BackGround Work Sample'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Pref value: $_prefValue   ServerData length: $_serverValue",),
              /*ValueListenableBuilder<Box<GithubRepos>>(
                valueListenable: BoxInstances().githubRepoBox!.listenable(),
                builder: (context, box, _) {
                  final storages = box.values.toList().cast<GithubRepos>();
                  return buildContent(storages);
                },
              ),*/
              ElevatedButton(onPressed: () async {
                loadData();
              }, child: const Text("Fetch"),)
            ],
          ),
        ));
  }

  Widget buildContent(List<GithubRepos> storages) {
    List<Widget> textListView = [];
    for(int i=0; i<storages.length;i++){
      textListView.add(Text("${storages[i].items?[i]?.id}"));
    }
    return Column(
     children: textListView,
    );
  }
}