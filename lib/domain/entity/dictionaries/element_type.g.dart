// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ElementTypeAdapter extends TypeAdapter<ElementType> {
  @override
  final int typeId = 3;

  @override
  ElementType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ElementType(
      id: fields[0] as int,
      title: fields[1] as String,
      workCatIds: (fields[2] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ElementType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.workCatIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
