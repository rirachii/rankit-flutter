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

  @HiveField(4)
  late String? listImgUrl;

  @HiveField(5, defaultValue: "Private") // Private, Public, Unlisted
  late String? visibility;

  @HiveField(6)
  late DateTime dateCreated;

  @HiveField(7)
  late DateTime lastUpdated;

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
}
