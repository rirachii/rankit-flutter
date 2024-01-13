// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListDataAdapter extends TypeAdapter<ListData> {
  @override
  final int typeId = 0;

  @override
  ListData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListData(
      listId: fields[0] as String,
      listName: fields[1] as String,
      listDescription:
          fields[2] == null ? 'No description' : fields[2] as String,
      items: (fields[3] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, String>())),
    );
  }

  @override
  void write(BinaryWriter writer, ListData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.listId)
      ..writeByte(1)
      ..write(obj.listName)
      ..writeByte(2)
      ..write(obj.listDescription)
      ..writeByte(3)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
