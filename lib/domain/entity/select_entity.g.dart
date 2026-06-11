// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SelectObjectAdapter extends TypeAdapter<SelectObject> {
  @override
  final int typeId = 6;

  @override
  SelectObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SelectObject(
      id: fields[0] as String,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SelectObject obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
