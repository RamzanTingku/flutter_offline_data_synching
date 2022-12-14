import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'github_user.g.dart';

@HiveType(typeId: 110)
class GithubUser extends HiveObject {
  @HiveField(0)
  int? totalCount;
  @HiveField(1)
  bool? incompleteResults;
  @HiveField(2)
  List<Items>? items;
  @HiveField(3)
  late String timeStamp;

  GithubUser({this.totalCount, this.incompleteResults, this.items, required this.timeStamp});

  GithubUser.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    incompleteResults = json['incomplete_results'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    timeStamp =  DateFormat('dd/MM HH:mm:ss').format(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    data['incomplete_results'] = incompleteResults;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GithubUser &&
          runtimeType == other.runtimeType &&
          totalCount == other.totalCount &&
          incompleteResults == other.incompleteResults &&
          items == other.items;

  @override
  int get hashCode =>
      totalCount.hashCode ^ incompleteResults.hashCode ^ items.hashCode;
}

@HiveType(typeId: 112)
class Items extends HiveObject{
  @HiveField(0)
  String? login;
  @HiveField(1)
  int? id;
  @HiveField(2)
  String? avatarUrl;

  Items({this.login, this.id, this.avatarUrl});

  Items.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['id'] = id;
    data['avatar_url'] = avatarUrl;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Items &&
          runtimeType == other.runtimeType &&
          login == other.login &&
          id == other.id &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode => login.hashCode ^ id.hashCode ^ avatarUrl.hashCode;
}
