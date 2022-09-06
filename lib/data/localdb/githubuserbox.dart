import 'package:flutter_offline_data_synching/data/localdb/basebox.dart';
import 'package:flutter_offline_data_synching/data/localdb/boxinstances.dart';
import 'package:flutter_offline_data_synching/data/model/githubuser/github_user.dart';
import 'package:hive/hive.dart';

class GithubUserBox extends BaseBox<GithubUser>{
  static const boxName = "github_user";
  @override
  Future<void> initHiveAdapters() async {
    Hive.registerAdapter(ItemsAdapter());
    Hive.registerAdapter(GithubUserAdapter());
    await Hive.openBox<GithubUser>(boxName);
    BoxInstances().githubUserBox =  Hive.box<GithubUser>(boxName);
  }

  @override
  Future<Box<GithubUser>> getBoxes() async {
    if(BoxInstances().githubUserBox == null) await initHiveAdapters();
    return BoxInstances().githubUserBox!;
  }

}