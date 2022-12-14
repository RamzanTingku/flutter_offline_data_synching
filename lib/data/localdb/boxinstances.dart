import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:hive_flutter/adapters.dart';

class BoxInstances{
  static final BoxInstances _instance = BoxInstances._internal();
  factory BoxInstances() {
    return _instance;
  }
  BoxInstances._internal();

  Future<void> initHive() async => await Hive.initFlutter();

  Box<GithubRepos>? githubRepoBox;
  Box<GithubUser>? githubUserBox;

  Future<void> closeBoxes() async {
    // githubRepoBox?.compact();
    await githubRepoBox?.close();
    await githubUserBox?.close();
    await Hive.close();
  }
}