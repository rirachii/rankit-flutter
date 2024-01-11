import 'package:hive/hive.dart';

// part 'ListData.g.dart';

@HiveType(typeId: 0, adapterName: "MyItemAdapter")
class Item extends HiveObject {
  @HiveField(0)
  String? itemId;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? img;

  @HiveField(3)
  String? description;

  Item({
    this.itemId,
    this.name,
    this.img,
    this.description,
  });
}

class MyItemAdapter extends TypeAdapter<Item> {
  @override
  final typeId = 0;

  @override
  Item read(BinaryReader reader) {
    return Item(
      itemId: reader.read(),
      name: reader.read(),
      img: reader.read(),
      description: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer.write(obj.itemId);
    writer.write(obj.name);
    writer.write(obj.img);
    writer.write(obj.description);
  }
}

@HiveType(typeId: 1, adapterName: "MyListDataAdapter")
class ListData extends HiveObject {
  @HiveField(0)
  String listId;

  @HiveField(1)
  String listName;

  @HiveField(2)
  String listDescription;

  @HiveField(3)
  String? listImg;

  @HiveField(4)
  List<Item> items;

  @HiveField(5)
  String? visibility;

  @HiveField(6)
  String? dateCreated;

  @HiveField(7)
  String? lastUpdated;

  @HiveField(8)
  String? updateNote;

  @HiveField(9)
  int? likes;

  @HiveField(10)
  int? completed;

  @HiveField(11)
  String? creatorId;

  @HiveField(12)
  String? creatorName;

  @HiveField(13)
  String? creatorPfp;

  @HiveField(14)
  List<String>? tags;

  ListData({
    required this.listId,
    required this.listName,
    required this.listDescription,
    required this.items,
    this.listImg,
    this.visibility,
    this.dateCreated,
    this.lastUpdated,
    this.updateNote,
    this.likes,
    this.completed,
    this.creatorId,
    this.creatorName,
    this.creatorPfp,
    this.tags,
  });
}

class MyListDataAdapter extends TypeAdapter<ListData> {
  @override
  final typeId = 1;

  @override
  ListData read(BinaryReader reader) {
    return ListData(
      listId: reader.read(),
      listName: reader.read(),
      listDescription: reader.read(),
      listImg: reader.read(),
      items: reader.read(),
      visibility: reader.read(),
      dateCreated: reader.read(),
      lastUpdated: reader.read(),
      updateNote: reader.read(),
      likes: reader.read(),
      completed: reader.read(),
      creatorId: reader.read(),
      creatorName: reader.read(),
      creatorPfp: reader.read(),
      tags: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ListData obj) {
    writer.write(obj.listId);
    writer.write(obj.listName);
    writer.write(obj.listDescription);
    writer.write(obj.listImg);
    writer.write(obj.items);
    writer.write(obj.visibility);
    writer.write(obj.dateCreated);
    writer.write(obj.lastUpdated);
    writer.write(obj.updateNote);
    writer.write(obj.likes);
    writer.write(obj.completed);
    writer.write(obj.creatorId);
    writer.write(obj.creatorName);
    writer.write(obj.creatorPfp);
    writer.write(obj.tags);
  }
}
