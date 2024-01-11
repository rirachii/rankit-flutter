import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ListData extends HiveObject {
  @HiveField(0)
  late String title;
}
class ListDataAdapter extends TypeAdapter<ListData> {
  @override
  final typeId = 0;

  @override
  ListData read(BinaryReader reader) {
    return ListData()
      ..title = reader.read();
  }

  @override
  void write(BinaryWriter writer, ListData obj) {
    writer.write(obj.title);
  }
}