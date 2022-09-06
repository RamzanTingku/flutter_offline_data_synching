import 'package:hive/hive.dart';
part 'github_repo.g.dart';

@HiveType(typeId: 10)
class GithubRepos extends HiveObject{
  @HiveField(0)
  int? totalCount;
  @HiveField(1)
  bool? incompleteResults;
  @HiveField(2)
  List<Items>? items;

  GithubRepos({this.totalCount, this.incompleteResults, this.items});

  GithubRepos.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    incompleteResults = json['incomplete_results'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
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
      other is GithubRepos &&
          runtimeType == other.runtimeType &&
          totalCount == other.totalCount &&
          incompleteResults == other.incompleteResults &&
          items == other.items;

  @override
  int get hashCode =>
      totalCount.hashCode ^ incompleteResults.hashCode ^ items.hashCode;
}

@HiveType(typeId: 13)
class Items  extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  Owner? owner;
  @HiveField(5)

  Items(
      {this.id,
        this.name,
        this.owner});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Items &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          owner == other.owner;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      owner.hashCode;
}

@HiveType(typeId: 21)
class Owner  extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? avatarUrl;

  Owner({this.id, this.avatarUrl});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar_url'] = avatarUrl;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Owner &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode => id.hashCode ^ avatarUrl.hashCode;
}