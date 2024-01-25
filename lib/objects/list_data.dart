import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'item.dart';
part 'list_data.g.dart';

@HiveType(typeId: 0)
class ListData extends HiveObject {
  @HiveField(0)
  late String listId;

  @HiveField(1)
  late String listName;

  @HiveField(2, defaultValue: 'No description')
  late String listDescription;

  @HiveField(3)
  late List<Item> items;

  @HiveField(4)
  late String? listImgUrl;

  @HiveField(5, defaultValue: "Private") // Private, Public, Unlisted
  late String? visibility;

  @HiveField(6)
  late Timestamp dateCreated;

  @HiveField(7)
  late Timestamp lastUpdated;

  @HiveField(8)
  late String? updateNote;

  @HiveField(9)
  late int? likes;

  @HiveField(10)
  late int? completed;

  @HiveField(11)
  late String? creatorId;

  @HiveField(12)
  late String? creatorName;

  @HiveField(13)
  late String? creatorPfp;

  @HiveField(14)
  late List<String>? tags;

  ListData(
      {required this.listId,
      required this.listName,
      required this.listDescription,
      required this.items,
      required this.listImgUrl,
      required this.visibility,
      required this.dateCreated,
      required this.lastUpdated,
      required this.updateNote,
      required this.likes,
      required this.completed,
      required this.creatorId,
      required this.creatorName,
      required this.creatorPfp,
      required this.tags});

  Map<String, dynamic> toMap() { 
    List<Map<String, dynamic>> itemsList = [];
    for (Item item in items) {
      itemsList.add(item.toMap());
    }
    return {
      'listId': listId,
      'listName': listName,
      'listDescription': listDescription,
      'items': itemsList,
      'listImgUrl': listImgUrl,
      'visibility': visibility,
      'dateCreated': dateCreated,
      'lastUpdated': lastUpdated,
      'updateNote': updateNote,
      'likes': likes,
      'completed': completed,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorPfp': creatorPfp,
      'tags': tags,
    };
  }

  factory ListData.fromMap(Map<String, dynamic> map) {
    List<Item> itemsList = [];
    for (Map<String, dynamic> item in map['items']) {
      itemsList.add(Item.fromMap(item));
    }
    
    return ListData(
      listId: map['listId'],
      listName: map['listName'],
      listDescription: map['listDescription'],
      items: itemsList,
      listImgUrl: map['listImgUrl'],
      visibility: map['visibility'],
      // dateCreated: (map['dateCreated'] as Timestamp).toDate(),
      // lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
      dateCreated: map['dateCreated'],
      lastUpdated: map['lastUpdated'],
      updateNote: map['updateNote'],
      likes: map['likes'],
      completed: map['completed'],
      creatorId: map['creatorId'],
      creatorName: map['creatorName'],
      creatorPfp: map['creatorPfp'],
      tags: List<String>.from(map['tags']),
    );
  }

}
