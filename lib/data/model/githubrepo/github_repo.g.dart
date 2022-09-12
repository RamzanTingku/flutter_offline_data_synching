// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GithubReposAdapter extends TypeAdapter<GithubRepos> {
  @override
  final int typeId = 10;

  @override
  GithubRepos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GithubRepos(
      totalCount: fields[0] as int?,
      incompleteResults: fields[1] as bool?,
      items: (fields[2] as List?)?.cast<Items>(),
      timeStamp: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GithubRepos obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalCount)
      ..writeByte(1)
      ..write(obj.incompleteResults)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GithubReposAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemsAdapter extends TypeAdapter<Items> {
  @override
  final int typeId = 13;

  @override
  Items read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Items(
      id: fields[0] as int?,
      name: fields[1] as String?,
      owner: fields[2] as Owner?,
    );
  }

  @override
  void write(BinaryWriter writer, Items obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.owner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OwnerAdapter extends TypeAdapter<Owner> {
  @override
  final int typeId = 21;

  @override
  Owner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Owner(
      id: fields[0] as int?,
      avatarUrl: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Owner obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.avatarUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
