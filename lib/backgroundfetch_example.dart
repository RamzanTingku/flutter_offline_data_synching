import 'package:flutter/material.dart';
import 'package:flutter_offline_data_synching/background_services/backgroundfetch/bf_task_registers.dart';
import 'package:flutter_offline_data_synching/background_services/task_constants.dart';
import 'package:flutter_offline_data_synching/background_services/task_registor_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/localdb/githubuserbox.dart';
import 'data/model/githubuser/github_user.dart';
import 'data/pref_manager/pref_manager.dart';

class BackgroundFetchExample extends StatefulWidget {
  const BackgroundFetchExample({Key? key}) : super(key: key);

  @override
  BackgroundFetchExampleState createState() => BackgroundFetchExampleState();
}

class BackgroundFetchExampleState extends State<BackgroundFetchExample> {
  List<GithubUser> _userSavedData = [];
  int _prefValueGithubUser = 0;
  late TaskRegisterHelper _taskRegisterHelper;

  @override
  void initState() {
    super.initState();
    _taskRegisterHelper = BfTaskRegisters();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _prefValueGithubUser =
        await PrefManager.instance.getPrefData(PrefManager.GithubUserCount);
    _userSavedData = await GithubUserBox().getAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              await loadData();
            },
            child: const SizedBox(
                width: double.infinity,
                child: Text(
                  "Refresh BackgroundFetch Data ",
                  textAlign: TextAlign.center,
                )),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _taskRegisterHelper.triggerOnce(
                        TaskConstants.UserOneOffTaskBF, 500);
                  },
                  child: const SizedBox(
                      width: double.infinity,
                      child: Text("User OneOff", textAlign: TextAlign.center)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _taskRegisterHelper.triggerPeriodic(
                        TaskConstants.UserPeriodicTaskBF, 500);
                  },
                  child: const SizedBox(
                      width: double.infinity,
                      child:
                          Text("User Periodic", textAlign: TextAlign.center)),
                ),
              ),
            ],
          ),
          Text(
            "Pref value: $_prefValueGithubUser   Saved Data length: ${_userSavedData.length}",
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
            itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                        child: Text(_userSavedData[index].timeStamp,
                            textAlign: TextAlign.start)),
                  ],
                );
            },
            itemCount: _userSavedData.length,
          ),
              ))
        ],
      ),
    );
  }
}
