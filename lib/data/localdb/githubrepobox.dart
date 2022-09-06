import 'package:flutter_offline_data_synching/data/localdb/basebox.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:hive_flutter/adapters.dart';

class GithubRepoBox extends BaseBox<GithubRepos>{
  static const boxName = "github_repo";
  @override
  Future<void> initHiveAdapters() async {
    Hive.registerAdapter(ItemsAdapter());
    Hive.registerAdapter(OwnerAdapter());
    Hive.registerAdapter(GithubReposAdapter());
    await Hive.openBox<GithubRepos>(boxName);
    BoxInstances().githubRepoBox =  Hive.box<GithubRepos>(boxName);
  }

  @override
  Future<Box<GithubRepos>> getBoxes() async {
    if(BoxInstances().githubRepoBox == null) await initHiveAdapters();
    return BoxInstances().githubRepoBox!;
  }

  @override
  Box<GithubRepos> getBoxesSynchronous() {
    // TODO: implement getBoxesSynchronous
    throw UnimplementedError();
  }

}