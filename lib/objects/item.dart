import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 1)
class Item extends HiveObject{
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  Key? rank;

  String get getId {
    return id;
  }

  set setId(String newId) {
    id = newId;
  }

  String get getName {
    return name;
  }

  set setName(String newName) {
    name = newName;
  }

  String get getDescription {
    return description;
  }

  set setDescription(String newDescription) {
    description = newDescription;
  }

  String get getImageUrl {
    return imageUrl;
  }

  set setImageUrl(String newImageUrl) {
    imageUrl = newImageUrl;
  }

  Key? get getRank {
    return rank;
  }

  set setRank(Key newRank) {
    rank = newRank;
  }

  Item({required this.id, required this.name, required this.description, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }

}