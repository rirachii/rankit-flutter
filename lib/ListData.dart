// import 'package:hive/hive.dart';
// // import 'ItemData.dart';

// @HiveType(typeId: 0, adapterName: "MyListDataAdapter")
// class ListData extends HiveObject {

//   @HiveField(4)
//   String? listImgUrl;

//   @HiveField(5)
//   String? visibility;

//   @HiveField(6)
//   String? dateCreated;

//   @HiveField(7)
//   String? lastUpdated;

//   @HiveField(8)
//   String? updateNote;

//   @HiveField(9)
//   int? likes;

//   @HiveField(10)
//   int? completed;

//   @HiveField(11)
//   String? creatorId;

//   @HiveField(12)
//   String? creatorName;

//   @HiveField(13)
//   String? creatorPfp;

//   @HiveField(14)
//   List<String>? tags;

//   ListData({
//     required this.listId,
//     required this.listName,
//     required this.listDescription,
//     this.items,
//     this.listImg,
//     this.visibility,
//     this.dateCreated,
//     this.lastUpdated,
//     this.updateNote,
//     this.likes,
//     this.completed,
//     this.creatorId,
//     this.creatorName,
//     this.creatorPfp,
//     this.tags,
//   });
// }

import 'package:hive/hive.dart';

part 'ListData.g.dart';

@HiveType(typeId: 0)
class ListData extends HiveObject {
  @HiveField(0)
  late String listId;

  @HiveField(1)
  late String listName;

  @HiveField(2, defaultValue: 'No description')
  late String listDescription;

  @HiveField(3)
  late List<Map<String, String>> items;

  ListData(
    {required this.listId,
    required this.listName,
    required this.listDescription,
    required this.items});
}
