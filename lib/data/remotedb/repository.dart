import 'dart:convert';

import 'package:flutter_offline_data_synching/data/model/githubrepo/github_repo.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:http/http.dart' as http;

class Repository{
  static Future<GithubRepos> getGithubRepos() async {
    final response = await http.get(Uri.parse('https://api.github.com/search/repositories?q=Android'));
    if (response.statusCode == 200) {
      return GithubRepos.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<GithubUser> getGithubUser() async {
    final response = await http.get(Uri.parse('https://api.github.com/search/users?q=ramzan'));
    if (response.statusCode == 200) {
      return GithubUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}