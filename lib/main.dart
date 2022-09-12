import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_offline_data_synching/background_services/task_registors.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubuserbox.dart';
import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:flutter_offline_data_synching/data/pref_manager/pref_manager.dart';
import 'package:flutter_offline_data_synching/local_notification/notification_service.dart';
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
  List<GithubRepos> _repoSavedData = [];
  List<GithubUser> _userSavedData = [];
  int _prefValueGithubRepo = 0;
  int _prefValueGithubUser = 0;
  late StreamSubscription _loginSubscription;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _prefValueGithubUser = await PrefManager.instance.getPrefData(PrefManager.GithubUserCount);
    _prefValueGithubRepo = await PrefManager.instance.getPrefData(PrefManager.GithubRepoCount);
    _repoSavedData = await GithubRepoBox().getAllData();
    _userSavedData = await GithubUserBox().getAllData();
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateRepoOnceWM();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github Repo OneOff WM",textAlign: TextAlign.center)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateRepoPeriodicWM();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github Repo Periodic WM",textAlign: TextAlign.center)),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateRepoOnceBF();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github Repo OneOff BF",textAlign: TextAlign.center)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateRepoPeriodicBF();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github Repo Periodic BF",textAlign: TextAlign.center)),
                                  ),
                                ),
                              ],
                            ),
                            Text("Pref value: $_prefValueGithubRepo   Saved Data length: ${_repoSavedData.length}",),
                            buildContentForRepo(_repoSavedData),
                            /*ValueListenableBuilder<Box<GithubRepos>>(
                              valueListenable: BoxInstances().githubRepoBox!.listenable(),
                              builder: (context, box, _) {
                                final storages = box.values.toList().cast<GithubRepos>();
                                return buildContent(storages);
                              },
                            ),*/
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateUserOnceWM();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github User OneOff WM",textAlign: TextAlign.center)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateUserPeriodicWM();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github User Periodic WM",textAlign: TextAlign.center)),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateUserOnceBF();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github User OneOff BF",textAlign: TextAlign.center)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await TaskRegisters.updateUserPeriodicBF();
                                    },
                                    child: const SizedBox(width: double.infinity, child: Text("Github User Periodic BF",textAlign: TextAlign.center)),
                                  ),
                                ),
                              ],
                            ),
                            Text("Pref value: $_prefValueGithubUser   Saved Data length: ${_userSavedData.length}",),
                            buildContentForUser(_userSavedData)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildContentForRepo(List<GithubRepos> storages) {
    List<Widget> textListView = [];
    for(int i=0; i<storages.length;i++){
      textListView.add(Text("${storages[i].timeStamp}"));
    }
    return Column(
     children: textListView,
    );
  }

  Widget buildContentForUser(List<GithubUser> storages) {
    List<Widget> textListView = [];
    for(int i=0; i<storages.length;i++){
      textListView.add(Text("${storages[i].timeStamp}"));
    }
    return Column(
     children: textListView,
    );
  }
}