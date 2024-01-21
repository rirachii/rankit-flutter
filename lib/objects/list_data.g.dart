// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_data.dart';

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
      items: (fields[3] as List).cast<Item>(),
      listImgUrl: fields[4] as String?,
      visibility: fields[5] == null ? 'Private' : fields[5] as String?,
      dateCreated: fields[6] as DateTime,
      lastUpdated: fields[7] as DateTime,
      updateNote: fields[8] as String?,
      likes: fields[9] as int?,
      completed: fields[10] as int?,
      creatorId: fields[11] as String?,
      creatorName: fields[12] as String?,
      creatorPfp: fields[13] as String?,
      tags: (fields[14] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ListData obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.listId)
      ..writeByte(1)
      ..write(obj.listName)
      ..writeByte(2)
      ..write(obj.listDescription)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.listImgUrl)
      ..writeByte(5)
      ..write(obj.visibility)
      ..writeByte(6)
      ..write(obj.dateCreated)
      ..writeByte(7)
      ..write(obj.lastUpdated)
      ..writeByte(8)
      ..write(obj.updateNote)
      ..writeByte(9)
      ..write(obj.likes)
      ..writeByte(10)
      ..write(obj.completed)
      ..writeByte(11)
      ..write(obj.creatorId)
      ..writeByte(12)
      ..write(obj.creatorName)
      ..writeByte(13)
      ..write(obj.creatorPfp)
      ..writeByte(14)
      ..write(obj.tags);
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
