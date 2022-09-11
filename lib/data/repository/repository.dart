import 'package:flutter_offline_data_synching/data/localdb/githubrepobox.dart';
import 'package:flutter_offline_data_synching/data/localdb/githubuserbox.dart';
import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:flutter_offline_data_synching/data/remotedb/remote_data.dart';

class Repository{
  Future<List<GithubRepos>> getGithubRepos() async {
    var repos = await RemoteData.getGithubRepos();
    await GithubRepoBox().add(repos);
    return await GithubRepoBox().getAllData();
  }

  Future<List<GithubUser>> getGithubUser() async {
    var user = await RemoteData.getGithubUser();
    await GithubUserBox().add(user);
    return await GithubUserBox().getAllData();
  }
}