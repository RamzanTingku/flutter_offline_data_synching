import 'package:flutter/material.dart';
import 'package:flutter_offline_data_synching/background_services/task_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_services/task_registor_helper.dart';
import 'background_services/workmanager/wm_task_registers.dart';
import 'data/localdb/githubrepobox.dart';
import 'data/model/githubrepo/github_repo.dart';
import 'data/pref_manager/pref_manager.dart';

class WorkmanagerExample extends StatefulWidget {
  const WorkmanagerExample({Key? key}) : super(key: key);

  @override
  _WorkmanagerExampleState createState() => _WorkmanagerExampleState();
}

class _WorkmanagerExampleState extends State<WorkmanagerExample> {
  List<GithubRepos> _repoSavedData = [];
  int _prefValueGithubRepo = 0;
  late TaskRegisterHelper _taskRegisterHelper;

  @override
  void initState() {
    super.initState();
    _taskRegisterHelper = WMTaskRegisters();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _prefValueGithubRepo = await PrefManager.instance.getPrefData(PrefManager.GithubRepoCount);
    _repoSavedData = await GithubRepoBox().getAllData();
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
            child: const SizedBox(width: double.infinity, child: Text("Refresh Workmanager Data", textAlign: TextAlign.center,)),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _taskRegisterHelper.triggerOnce(TaskConstants.RepoOneOffTaskWM, 500);
                  },
                  child: const SizedBox(width: double.infinity, child: Text("Repo OneOff",textAlign: TextAlign.center)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _taskRegisterHelper.triggerPeriodic(TaskConstants.RepoPeriodicTaskWM, 500);
                  },
                  child: const SizedBox(width: double.infinity, child: Text("Repo Periodic",textAlign: TextAlign.center)),
                ),
              ),
            ],
          ),
          Text("Pref value: $_prefValueGithubRepo   Saved Data length: ${_repoSavedData.length}",),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(itemBuilder: (context, index) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Text(_repoSavedData[index].timeStamp, textAlign: TextAlign.start)),
                  ],
                );
              }, itemCount: _repoSavedData.length),
            ),
          )

        ],
      ),
    );
  }
}